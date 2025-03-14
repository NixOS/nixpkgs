{
  lib,
  fetchFromGitHub,
  stdenv,
  python3Full,
  makeWrapper,
  makeDesktopItem,
}:
let
  pkgVersion = "5.12.2";
  pythonEnv = python3Full.buildEnv.override {
    extraLibs = with python3Full.pkgs.pythonPackages; [
      requests
      pillow
      watchdog
      semantic-version
      psutil
    ];
    ignoreCollisions = true;
  };
in
stdenv.mkDerivation rec {
  pname = "edmarketconnector";
  version = "${pkgVersion}";

  src = fetchFromGitHub {
    owner = "EDCD";
    repo = "EDMarketConnector";
    tag = "Release/${pkgVersion}";
    hash = "sha256-3ywu/EJdIsKqTN3uaA5F0tZK6tybl483Yiwqh7W4yCc=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "EDMarketConnector";
      exec = "EDMarketConnector";
      icon = "EDMarketConnector";
      desktopName = "EDMarketConnector";
      categories = [
        "Game"
        "Utility"
      ];
      comment = meta.description;
      terminal = false;
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstallPhase

    install -Dm644 ${src}/io.edcd.EDMarketConnector.png $out/share/icons/hicolor/512x512/apps/io.edcd.EDMarketConnector.png

    mkdir -p "$out/share/applications/"
    cp "$src/io.edcd.EDMarketConnector.desktop" "$out/share/applications/"

    substituteInPlace "$out/share/applications/io.edcd.EDMarketConnector.desktop" \
      --replace-fail 'edmarketconnector' 'EDMarketConnector'

    makeWrapper ${pythonEnv}/bin/python $out/bin/EDMarketConnector \
      --add-flags "${src}/EDMarketConnector.py $@"

    runHook postInstallPhase
  '';

  meta = {
    homepage = "https://github.com/EDCD/EDMarketConnector";
    description = "Uploads Elite: Dangerous market data to popular trading tools";
    longDescription = "Downloads commodity market and other station data from the game Elite: Dangerous for use with all popular online and offline trading tools. ";
    changelog = "https://github.com/EDCD/EDMarketConnector/releases/tag/Release%2F${version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.x86_64;
    mainProgram = "EDMarketConnector";
    maintainers = with lib.maintainers; [ jiriks74 ];
  };
}
