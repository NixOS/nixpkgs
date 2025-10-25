{
  lib,
  fetchFromGitHub,
  flutter,
  zenity,
  makeWrapper,
  pkg-config,
  makeDesktopItem,
  copyDesktopItems,

}:

flutter.buildFlutterApplication rec {
  pname = "chameleonultragui";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "GameTec-live";
    repo = "ChameleonUltraGUI";
    rev = version;
    hash = "sha256-9Hwjx1nt/QD520eLMAB5xyFjOGfjZSwS83ARNn8GsFo=";
  };

  sourceRoot = "${src.name}/chameleonultragui";

  # curl https://raw.githubusercontent.com/GameTec-live/ChameleonUltraGUI/main/chameleonultragui/pubspec.lock | yq > pubspec.lock.json
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git_hashes.json;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    zenity
  ];

  postInstall = ''
    # Handle desktop icons
    mkdir -p $out/share/pixmaps
    cp ./aur/chameleonultragui.png $out/share/pixmaps/chameleonultragui.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "chameleonultragui";
      desktopName = "Chameleon Ultra GUI";
      genericName = "Chameleon Ultra GUI";
      comment = "GUI app for Chameleon Ultra and Lite";
      exec = "chameleonultragui %u";
      icon = "chameleonultragui";
      terminal = false;
      type = "Application";
      categories = [
        "Utility"
      ];
      keywords = [
        "Flutter"
        "share"
        "files"
        "chameleon"
        "chameleonultra"
        "chameleonlite"
      ];
    })
  ];

  meta = {
    description = "A cross platform GUI for the Chameleon Ultra written in flutter";
    homepage = "https://github.com/GameTec-live/ChameleonUltraGUI";
    changelog = "https://github.com/GameTec-live/ChameleonUltraGUI/releases/${version}";
    license = lib.licenses.gpl3;
    mainProgram = "chameleonultragui";
    maintainers = with lib.maintainers; [ wilaz ];
    platforms = lib.platforms.linux;
  };
}
