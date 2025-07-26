{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  librsvg,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "am32-config-tool";
  version = "0-unstable-2024-12-29";

  src = fetchFromGitHub {
    owner = "am32-firmware";
    repo = "ConfigTool";
    rev = "3dc3b25b17c88a30e147c1c7c15279c586b6f3fa";
    hash = "sha256-bADGdIe1Mw/j/Vh7/ecuEloOyMlietUMLEHltt101dQ=";
  };

  postPatch =
    ''
      # Replace hardcoded bin install path
      substituteInPlace SerialPortConnector.pro \
        --replace-fail '/opt/$$''
    + ''
      {TARGET}/bin' "$out/bin"
    '';

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    copyDesktopItems

    librsvg # For converting the svg logo to png
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtserialport
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "AM32 Configurator";
      exec = "SerialPortConnector";
      icon = "am32";
      desktopName = "AM32 Configurator";
      comment = "AM32 Offline Configuration Tool";
      categories = [ "Development" ];
    })
  ];

  qmakeFlags = [
    "./SerialPortConnector.pro"
  ];

  postInstall = ''
    mkdir -p $out/share/pixmaps
    rsvg-convert -w 256 -h 256 -o $out/share/pixmaps/am32.png ${./am32-logo.svg}
    cp ${./am32-logo.svg} $out/share/pixmaps/am32.svg
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "AM32 Offline Configuration Tool";
    homepage = "https://github.com/am32-firmware/ConfigTool";
    mainProgram = "SerialPortConnector";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
