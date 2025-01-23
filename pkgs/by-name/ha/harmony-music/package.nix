{
  autoPatchelfHook,
  lib,
  fetchFromGitHub,
  flutter324,
  pkg-config,
  makeDesktopItem,
  libayatana-appindicator,
  copyDesktopItems,
  mpv,
}:
flutter324.buildFlutterApplication rec {
  pname = "harmony-music";
  version = "1.10.31";

  src = fetchFromGitHub {
    owner = "anandnet";
    repo = "Harmony-Music";
    tag = "v${version}";
    hash = "sha256-hHwkBNqYcwYlez3SCdc+I+LKyduHU93LCFaAZqpKIO4=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "harmony-music";
      exec = "harmonymusic";
      icon = "harmony-music";
      genericName = "Harmony Music";
      desktopName = "Harmony Music";
      categories = [
        "AudioVideo"
      ];
      keywords = [
        "Music"
        "Media"
        "Streaming"
      ];
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    libayatana-appindicator
  ];

  gitHashes = {
    device_equalizer = "sha256-fvS611D/0U5yJC5i88JdyVNhJozt8tXPhgkkvHgIDRo=";
    just_audio_media_kit = "sha256-cNuKwOAEcFCTfbKhvBvYAdmD5qFeNW16jc3A+6ID3bM=";
    player_response = "sha256-4Lc6yelLzYjH3K9rzzHHJ1XDyAyQK1xFGfj/rC7wAkg=";
    sdk_int = "sha256-ABlghY7RE/E/1G7xP10LuVSWPxbg4jyfLon8XMv8rYo=";
    sidebar_with_animation = "sha256-Y7dTO4wN7cOmm2mnzQPW/gDYltLr7wMKMXbGtAg8WzY=";
  };

  postInstall = ''
    install -Dm644 ./assets/icons/icon.png $out/share/pixmaps/harmony-music.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/harmony-music/lib:${
      lib.makeLibraryPath [
        mpv
      ]
    }"
  '';

  meta = {
    description = "Cross platform App for streaming Music";
    homepage = "https://github.com/anandnet/Harmony-Music";
    mainProgram = "harmonymusic";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
