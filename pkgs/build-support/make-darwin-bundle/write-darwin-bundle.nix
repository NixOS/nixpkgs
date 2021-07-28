{ writeScriptBin, lib, ... }:

let
  pListText = lib.generators.toPlist { } {
    CFBundleDevelopmentRegion = "English";
    CFBundleExecutable = "$name";
    CFBundleIconFiles = [ "$iconPlistArray" ];
    CFBundleIdentifier = "org.nixos.$name";
    CFBundleInfoDictionaryVersion = "6.0";
    CFBundleName = "$name";
    CFBundlePackageType = "APPL";
    CFBundleSignature = "???";
  };

# The generation of the CFBundleIconFiles array is a bit of a hack, since we
# will always end up with an empty first element (<string></string>) but macOS
# appears to ignore this which allows us to use the nix PList generator.
in writeScriptBin "write-darwin-bundle" ''
    shopt -s nullglob

    readonly prefix="$1"
    readonly name="$2"
    readonly exec="$3"
    iconPlistArray=""

    for icon in "$prefix/Applications/$name.app/Contents/Resources"/*; do
        iconPlistArray="$iconPlistArray</string><string>"$(basename "$icon")""
    done

    cat > "$prefix/Applications/$name.app/Contents/Info.plist" <<EOF
${pListText}
EOF

    cat > "$prefix/Applications/$name.app/Contents/MacOS/$name" <<EOF
#!/bin/bash
exec $prefix/bin/$exec
EOF

    chmod +x "$prefix/Applications/$name.app/Contents/MacOS/$name"
''
