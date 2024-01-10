{ lib
, fetchurl
, appimageTools
, makeWrapper
}:

let
  pname = "caido";
  version = "0.29.2";
  src = fetchurl {
    url = "https://storage.googleapis.com/caido-releases/v${version}/caido-desktop-linux-v${version}-e0f8102b.AppImage";
    hash = "sha256-4PgQK52LAX1zacmoUK0muIhrvFDF7anQ6sx35I+ErVs=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };

in appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libthai ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/caido.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/caido.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
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
