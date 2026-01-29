{
  myDesktopItemArgs,
  myMeta,
  mySrc,
  myVersion,

  flutter,
  lib,
  makeDesktopItem,
}:
flutter.buildFlutterApplication {
  pname = "nordvpn-gui";
  version = myVersion;

  src = mySrc;
  sourceRoot = "${mySrc.name}/gui";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

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
