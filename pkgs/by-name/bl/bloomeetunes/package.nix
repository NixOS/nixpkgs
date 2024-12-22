{
  autoPatchelfHook,
  lib,
  fetchFromGitHub,
  flutter324,
  mpv,
  pkg-config,
  makeDesktopItem,
  wrapGAppsHook3,
  copyDesktopItems,
}:
flutter324.buildFlutterApplication rec {
  pname = "bloomeetunes";
  version = "2.10.9";

  src = fetchFromGitHub {
    owner = "HemantKArya";
    repo = "BloomeeTunes";
    rev = "v${version}+152";
    hash = "sha256-Yv0aSq2eBcHKpy4PPjAhx194UW8Gm0UJlE+F+onZYFM=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "bloomeetunes";
      exec = "bloomee";
      icon = "bloomeetunes";
      genericName = "Music Player";
      desktopName = "Bloomee Tunes";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  postInstall = ''
    install -Dm644 ./assets/icons/bloomee_new_logo_c.png $out/share/pixmaps/bloomeetunes.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/bloomeetunes/lib:${
      lib.makeLibraryPath [
        mpv
      ]
    }"
  '';

  meta = {
    description = "Cross-platform music app designed to bring you ad-free tunes from various sources";
    homepage = "https://github.com/HemantKArya/BloomeeTunes";
    mainProgram = "bloomee";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
