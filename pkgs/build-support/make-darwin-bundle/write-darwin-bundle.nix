{ writeScriptBin, lib, ... }:

let
  pListText = lib.generators.toPlist { } {
    CFBundleDevelopmentRegion = "English";
    CFBundleExecutable = "$name";
    CFBundleIconFile = "$icon";
    CFBundleIconFiles = [ "$icon" ];
    CFBundleIdentifier = "org.nixos.$name";
    CFBundleInfoDictionaryVersion = "6.0";
    CFBundleName = "$name";
    CFBundlePackageType = "APPL";
    CFBundleSignature = "???";
  };
in writeScriptBin "write-darwin-bundle" ''
    shopt -s nullglob

    readonly prefix=$1
    readonly name=$2
    readonly exec=$3
    readonly icon=$4.icns
    readonly squircle=''${5:-1}
    readonly plist=$prefix/Applications/$name.app/Contents/Info.plist

    cat > "$plist" <<EOF
${pListText}
EOF

  if [[ $squircle == 0 || $squircle == "false" ]]; then
    sed  '/CFBundleIconFiles/,\|</array>|d' -i "$plist"
  fi

    cat > "$prefix/Applications/$name.app/Contents/MacOS/$name" <<EOF
#!/bin/bash
exec $prefix/bin/$exec
EOF

    chmod +x "$prefix/Applications/$name.app/Contents/MacOS/$name"
''
