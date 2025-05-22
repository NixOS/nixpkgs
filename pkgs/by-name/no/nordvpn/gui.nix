{
  myDesktopItemArgs,
  myMeta,
  mySrc,
  myVersion,

  copyDesktopItems,
  flutter,
  lib,
  makeDesktopItem,
}:
flutter.buildFlutterApplication {
  pname = "nordvpn-gui";
  version = myVersion;

  src = mySrc;
  sourceRoot = "${mySrc.name}/gui";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # finds X11 using pkg-config
  patches = [ ./linux-cmake.patch ];

  desktopItems = [
    (makeDesktopItem (
      myDesktopItemArgs
      // {
        comment = "NordVPN's GUI to manage vpn connection, settings, etc.";
        desktopName = "NordVPN GUI";
        exec = "nordvpn-gui";
        name = "nordvpn-gui";
        noDisplay = false;
        terminal = false;
      }
    ))
  ];

  meta = myMeta // {
    description = ''
      NordVPN gui application.
      Presumes the dependent NordVPN cli application.
    '';
    mainProgram = "nordvpn-gui";
  };
}
