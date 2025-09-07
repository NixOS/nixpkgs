{
  lib,
  fetchFromGitHub,
  flutter335,
  makeShellWrapper,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  mpv-unwrapped,
  libplacebo,
}:

let
  version = "1.1.4.1";
  rev = "288d554de9bd79ed52582d95517a3d2ea59e6e06";

  description = "Third-party Bilibili client developed in Flutter";
in
flutter335.buildFlutterApplication.override
  {
    # makeBinaryWrapper does not support `--run`.
    makeWrapper = makeShellWrapper;
  }
  {
    pname = "piliplus";
    inherit version;

    src = fetchFromGitHub {
      owner = "bggRGjQaUbCoE";
      repo = "PiliPlus";
      inherit rev;
      hash = "sha256-ia+qN3Oa8R7ZPN/IETedESv1+cSXKQOo158is0m/JJM=";
    };

    # Disable update check.
    postPatch = ''
      substituteInPlace lib/utils/update.dart \
        --replace-fail "if (kDebugMode) " ""
    '';

    pubspecLock = lib.importJSON ./pubspec.lock.json;
    gitHashes = lib.importJSON ./git-hashes.json;

    nativeBuildInputs = [ copyDesktopItems ];

    buildInputs = [
      alsa-lib
      mpv-unwrapped
      libplacebo
    ];

    # See lib/scripts/build.sh.
    preBuild = ''
      cat <<EOL > lib/build_config.dart
      class BuildConfig {
        static const int buildTime = $SOURCE_DATE_EPOCH;
        static const String commitHash = '${rev}';
      }
      EOL
    '';

    # The app attempts to get the total size of TMPDIR at startup.
    extraWrapProgramArgs = ''
      --run 'export TMPDIR="$(mktemp -d)"'
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
          "$out/share/icons/hicolor/$widthx$width/apps/piliplus.png"
      done
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "piliplus";
        exec = "piliplus";
        icon = "piliplus";
        desktopName = "PiliPlus";
        categories = [ "Video" ];
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
