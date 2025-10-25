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
  version = "0-unstable-2025-03-27";
  src = fetchurl {
    url = "https://archive.org/download/remotegamepad_amd64.tar_20250327/remotegamepad_amd64.tar.gz";
    hash = "sha256-nZ/oStf/vsw2lD1rDscvZTDDi1ID4QqZUEpZRVpnnjU=";
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

    install -m 755 -D remotegamepad $out/bin/remotegamepad
    install -m 644 -D 60-remotegamepad.rules $out/lib/udev/rules.d/60-remotegamepad.rules
    install -m 644 -D icon.png $out/share/icons/hicolor/256x256/apps/remotegamepad.png

    cp -r notices $out/bin
    cp -r icon.png $out/bin

    runHook postInstal
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
