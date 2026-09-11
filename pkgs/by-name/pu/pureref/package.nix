{
  lib,
  appimageTools,
  makeWrapper,
  runCommand,
  curl,
  gnugrep,
  cacert,
  writeShellScript,
  blockNetwork ? false,
}:
let
  pname = "pureref";
  version = "2.1.3";
  homepage = "https://www.pureref.com";

  kindCurl = ''curl -s -A "nixpkgs/Please contact maintainers if there is an issue"'';
  downloadKeyCmd = ''${kindCurl} "${homepage}/download.php" | grep '%3D%3D' | cut -d '"' -f2'';
  archiveUrl =
    v: k: "${homepage}/files/build.php?build=LINUX64.Appimage&version=${v}&downloadKey=${k}";

  src =
    runCommand "PureRef-${version}.AppImage"
      {
        nativeBuildInputs = [
          curl
          gnugrep
          cacert
        ];
        outputHash = "sha256-N5iyT/WFOFBZdfjHX6lZD2EqiOmTdYQEf2YIlN2o7/M=";
        outputHashMode = "flat";
      }
      ''
        key="$(${downloadKeyCmd})"
        curl -L "${archiveUrl version "$key"}" --output $out
      '';

  archive = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    mv $out/bin/pureref $out/bin/PureRef
    ln -s $out/bin/PureRef $out/bin/pureref
    cp -r ${archive}/usr/share $out
    wrapProgram $out/bin/PureRef \
      --set QT_QPA_PLATFORM xcb \
      --unset QT_STYLE_OVERRIDE \
      --set FONTCONFIG_FILE /etc/fonts/fonts.conf
  ''
  + lib.optionalString blockNetwork ''
    sed -i 's|--die-with-parent|--unshare-net\n --die-with-parent|' $out/bin/.PureRef-wrapped
  '';

  passthru.updateScript = writeShellScript "update-pureref" ''
    set -eux
    package_nix="${toString ./package.nix}"

    echo "Fetching latest version..."
    version=$(${kindCurl} "${homepage}/buildfinder.php" | sed -n 's/.*PureRef-\([0-9.]*\)_.*/\1/p')

    if [ -z "$version" ]; then
      echo "Failed to find version, contact nixpkgs maintainers"
      exit 1
    else
      echo "Found new version: $version"
    fi

    echo "Computing hash..."
    key=$(${downloadKeyCmd})
    url="${archiveUrl "$version" "$key"}"
    hash=$(nix-prefetch-url --type sha256 --name "PureRef-$version.AppImage" "$url")
    sri=$(nix hash convert --hash-algo sha256 --to sri "$hash")

    echo "Updating version in $package_nix to $version"
    sed -i "s|version = \".*\"|version = \"$version\"|" "$package_nix"
    echo "Updating hash in $package_nix to $sri"
    sed -i "s|outputHash = \".*\"|outputHash = \"$sri\"|" "$package_nix"
  '';

  meta = {
    description = "Reference Image Viewer";
    inherit homepage;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      elnudev
      husjon
      lnk3
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "pureref";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
