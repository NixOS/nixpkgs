{
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
    (makeDesktopItem {
      categories = [ "Network" ];
      comment = "NordVPN graphical user interface.";
      desktopName = "NordVPN GUI";
      exec = "nordvpn-gui";
      icon = "nordvpn";
      name = "nordvpn-gui";
      terminal = false;
      type = "Application";
    })
  ];

  meta = myMeta // {
    description = "NordVPN gui application for Linux.";
  };
}
