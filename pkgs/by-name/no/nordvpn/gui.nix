{
  desktopItemArgs,
  meta,
  src,
  version,

  copyDesktopItems,
  flutter,
  lib,
  makeDesktopItem,
  libx11,
}:
flutter.buildFlutterApplication {
  pname = "nordvpn-gui";
  inherit src version;

  sourceRoot = "${src.name}/gui";

  buildInputs = [
    libx11
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # finds X11 using pkg-config
  patches = [ ./linux-cmake.patch ];

  desktopItems = [
    (makeDesktopItem (
      desktopItemArgs
      // {
        comment = "NordVPN's GUI to manage vpn connection, settings, etc.";
        desktopName = "NordVPN GUI";
        exec = "nordvpn-gui";
        name = "nordvpn-gui";
      }
    ))
  ];

  meta = meta // {
    description = "NordVPN graphical interface";
    mainProgram = "nordvpn-gui";
  };
}
