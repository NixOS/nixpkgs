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
  version = "1.1.4.8";
  rev = "6ef9a24ed109d251eee4b0e4d6ed10932d90ef9d";
  revCount = "4176"; # this line is matched by regexp in update.rb
  commitDate = "1759647826"; # this line is matched by regexp in update.rb

  description = "Third-party Bilibili client developed in Flutter";
in
flutter335.buildFlutterApplication {
  pname = "piliplus";
  inherit version;

  src = fetchFromGitHub {
    owner = "bggRGjQaUbCoE";
    repo = "PiliPlus";
    inherit rev;
    hash = "sha256-is+y/foPvYWuBalKW2ujWXUUl30zW3Rce7OiqdoHYc4=";
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
      static const int versionCode = ${revCount};
      static const String versionName = '${version}';

      static const int buildTime = ${commitDate};
      static const String commitHash = '${rev}';
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
    changelog = "https://github.com/bggRGjQaUbCoE/PiliPlus/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux;
    mainProgram = "piliplus";
  };
}
