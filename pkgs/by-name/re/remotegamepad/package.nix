{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  cairo,
  libxcrypt-legacy,
}:

stdenv.mkDerivation {
  pname = "remotegamepad";
  version = "0-unstable-2025-02-02";
  src = fetchurl {
    url = "https://archive.org/download/remotegamepad_amd64.tar/remotegamepad_amd64.tar.gz";
    hash = "sha256-LqCRpyIiOLFRBqU75wUaYiYJTbg/C0RGaG43m9RUV6Q=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    cairo
    libxcrypt-legacy
  ];

  sourceRoot = ".";

  desktopItems = [
    (makeDesktopItem {
      name = "Remote Gamepad";
      exec = "remotegamepad";
      icon = "remotegamepad";
      desktopName = "Remote Gamepad";
      genericName = "Remote Gamepad";
      categories = [ "Game" ];
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -D remotegamepad $out/bin/remotegamepad

    cp -r notices $out/bin

    install -Dm644 icon.png $out/share/icons/hicolor/256x256/apps/remotegamepad.png
    runHook postInstall
  '';

  meta = {
    description = "Use your phone as a gamepad for your PC";
    homepage = "https://remotegamepad.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ astronaut0212 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "remotegamepad";
  };
}
