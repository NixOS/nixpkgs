{
  autoPatchelfHook,
  lib,
  fetchFromGitHub,
  flutter324,
  makeDesktopItem,
  libayatana-appindicator,
  copyDesktopItems,
  mpv,
  runCommand,
  _experimental-update-script-combinators,
  harmony-music,
  gitUpdater,
  yq,
  jdk,
}:

flutter324.buildFlutterApplication rec {
  pname = "harmony-music";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "anandnet";
    repo = "Harmony-Music";
    tag = "v${version}";
    hash = "sha256-czXtJeMcwYD0iBmYNhicywTPSnsW1Y2Yl3T2YS3uuWo=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    just_audio_media_kit = "sha256-cNuKwOAEcFCTfbKhvBvYAdmD5qFeNW16jc3A+6ID3bM=";
    sidebar_with_animation = "sha256-Y7dTO4wN7cOmm2mnzQPW/gDYltLr7wMKMXbGtAg8WzY=";
    youtube_explode_dart = "sha256-+3j+B+Ea1l/SzR8ZLp0vLYco77hkwn9VKRPvDeHqIeY=";
    terminate_restart = "sha256-NiznKbko9f2yWcI62MA2xc/NQgy/31fYqK0COHR1Wpk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    libayatana-appindicator
    jdk
  ];

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

  postInstall = ''
    install -Dm644 assets/icons/icon.png $out/share/pixmaps/harmony-music.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/harmony-music/lib:${lib.makeLibraryPath [ mpv ]}
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          buildInputs = [ yq ];
          inherit (harmony-music) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "harmony-music.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Cross platform App for streaming Music";
    homepage = "https://github.com/anandnet/Harmony-Music";
    mainProgram = "harmonymusic";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
