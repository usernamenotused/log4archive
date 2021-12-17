Add-Type -AssemblyName "system.io.compression.filesystem"
foreach($Drive in $(Get-PSDrive -PSProvider FileSystem)){ #added ErrorAction Ignore and search hidden files too
    Get-ChildItem $Drive.Root -Recurse -Include '*.jar', '*.zip' '*.war', '*.ear' -ea ignore -force | ForEach-Object {
        $fn = $_.FullName
        $z = [io.compression.zipfile]::OpenRead( $fn )
        switch -regex ($z.Entries.Name){ # switchout for Entries
          'log4j-core-2.1[0-4](?:\-alpha\d|\-beta\d|\.\d)\.jar' { Foreach( $item in $_ ) { Add-Content -path 'C:\temp\log4war.log' -value ('log4j Version in archive 2.10<2.15::'+$_ +'::'+ $fn) } }
          'log4j-core-2.[0-9](?:\-alpha\d|\-bedta\d|\.\d)\.jar' { Foreach( $item in $_ ) { Add-Content -path 'C:\temp\log4war.log' -value ('log4j Version in archive < 2.10 ::'+$_ +'::'+ $fn) } }
        }
    }
}
