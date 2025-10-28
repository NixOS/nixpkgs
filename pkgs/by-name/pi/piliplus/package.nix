{
  lib,
  fetchFromGitHub,
  flutter335,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  mpv-unwrapped,
  libplacebo,
  libappindicator,
}:

let
  srcInfo = lib.importJSON ./src-info.json;
  description = "Third-party Bilibili client developed in Flutter";
in
flutter335.buildFlutterApplication {
  pname = "piliplus";
  inherit (srcInfo) version;

  src = fetchFromGitHub {
    owner = "bggRGjQaUbCoE";
    repo = "PiliPlus";
    inherit (srcInfo) rev hash;
  };

  patches = [ ./disable-auto-update.patch ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    alsa-lib
    mpv-unwrapped
    libplacebo
    libappindicator
  ];

  # See lib/scripts/build.sh.
  preBuild = ''
    cat <<EOL > lib/build_config.dart
    class BuildConfig {
      static const int versionCode = ${toString srcInfo.revCount};
      static const String versionName = '${srcInfo.version}';

      static const int buildTime = ${toString srcInfo.commitDate};
      static const String commitHash = '${srcInfo.rev}';
    }
    EOL
  '';

  postInstall = ''
    declare -A sizes=(
      [mdpi]=128
      [hdpi]=192
      [xhdpi]=256
      [xxhdpi]=384
      [xxxhdpi]=512
    )
    for var in "''${!sizes[@]}"; do
      width=''${sizes[$var]}
      install -Dm644 "android/app/src/main/res/drawable-$var/splash.png" \
        "$out/share/icons/hicolor/''${width}x$width/apps/piliplus.png"
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "piliplus";
      exec = "piliplus";
      icon = "piliplus";
      desktopName = "PiliPlus";
      categories = [
        "Video"
        "AudioVideo"
      ];
      comment = description;
    })
  ];

  passthru.updateScript = ./update.rb;

  meta = {
    inherit description;
    homepage = "https://github.com/bggRGjQaUbCoE/PiliPlus";
    changelog = "https://github.com/bggRGjQaUbCoE/PiliPlus/releases/tag/${srcInfo.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux;
    mainProgram = "piliplus";
  };
}
