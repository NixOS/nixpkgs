{
  writeScriptBin,
  lib,
  makeBinaryWrapper,
}:

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
in
writeScriptBin "write-darwin-bundle" ''
      shopt -s nullglob

      readonly prefix=$1
      readonly name=$2
      # TODO: support executables with spaces in their names
      readonly execName=''${3%% *} # Before the first space
      [[ $3 =~ " " ]] && readonly execArgs=''${3#* } # Everything after the first space
      readonly icon=$4.icns
      readonly squircle=''${5:-1}
      readonly plist=$prefix/Applications/$name.app/Contents/Info.plist
      readonly binary=$prefix/bin/$execName
      readonly bundleExecutable=$prefix/Applications/$name.app/Contents/MacOS/$name

      cat > "$plist" <<EOF
  ${pListText}
  EOF

      if [[ $squircle == 0 || $squircle == "false" ]]; then
        sed  '/CFBundleIconFiles/,\|</array>|d' -i "$plist"
      fi

      if [[ -n "$execArgs" ]]; then
        (
          source ${makeBinaryWrapper}/nix-support/setup-hook
          # WORKAROUND: makeBinaryWrapper fails when -u is set
          set +u
          makeBinaryWrapper "$binary" "$bundleExecutable" --add-flags "$execArgs"
        )
      else
        ln -s "$binary" "$bundleExecutable"
      fi
''
