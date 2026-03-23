{
  lib,
  flutter338,
  fetchFromGitHub,
  yq-go,
  pkg-config,
  libsecret,
  jsoncpp,
  mpv-unwrapped,
  libass,
  keybinder3,
  ffmpeg,
  sdl3,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  _experimental-update-script-combinators,
  nix-update-script,
  runCommand,
  dart,
}:

flutter338.buildFlutterApplication rec {
  pname = "plezy";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "edde746";
    repo = "plezy";
    tag = version;
    hash = "sha256-bJ/Qho6hkjbGOFUJj3J4XKk4Eq+3PU1VFGxik5ht16c=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    imagemagick
  ];

  buildInputs = [
    libsecret
    jsoncpp
    mpv-unwrapped
    libass
    keybinder3
    ffmpeg
    sdl3
  ];

  postPatch = ''
    # Avoid FetchContent download of SDL3 during build.
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "set(BUNDLE_SDL3 ON CACHE BOOL \"\" FORCE)" \
                     "set(BUNDLE_SDL3 OFF CACHE BOOL \"\" FORCE)"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "plezy";
      exec = "plezy";
      icon = "plezy";
      desktopName = "Plezy";
      comment = "Modern cross-platform Plex client built with Flutter";
      categories = [
        "AudioVideo"
        "Video"
        "Player"
      ];
    })
  ];

  postInstall = ''
    install -Dm644 assets/plezy.png $out/share/icons/hicolor/128x128/apps/plezy.png
    for size in 16 24 32 48 64 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      convert assets/plezy.png -resize ''${size}x''${size} $out/share/icons/hicolor/''${size}x''${size}/apps/plezy.png
    done
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "plezy.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Modern cross-platform Plex client built with Flutter";
    homepage = "https://github.com/edde746/plezy";
    mainProgram = "plezy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      mio
      miniharinn
    ];
    platforms = lib.platforms.linux;
  };
}
