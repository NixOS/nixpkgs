{ lib
, fetchurl
, appimageTools
, makeWrapper
}:

let
  pname = "caido";
  version = "0.33.0";
  src = fetchurl {
    url = "https://storage.googleapis.com/caido-releases/v${version}/caido-desktop-v${version}-linux-x86_64.AppImage";
    hash = "sha256-MUQ1tVcIpLrC2RKsWDqv8MBGaHfh56OxIC/ARArQjiU=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };

in appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: [ pkgs.libthai ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/caido.desktop -t $out/share/applications
    install -m 444 -D ${appimageContents}/caido.png \
      $out/share/icons/hicolor/512x512/apps/caido.png
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = with lib; {
    description = "A lightweight web security auditing toolkit";
    homepage = "https://caido.io/";
    changelog = "https://github.com/caido/caido/releases/tag/v${version}";
    license = licenses.unfree;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "caido";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
