{
  lib,
  stdenv,
  stdenvNoCC,
  flutter347,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  libsecret,
  jsoncpp,
  mpv-unwrapped,
  libass,
  keybinder3,
  ffmpeg,
  zlib,
  libevdev,
  jdk,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  _7zz,
  makeBinaryWrapper,
  runCommand,
}:
let
  pname = "plezy";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "edde746";
    repo = "plezy";
    tag = version;
    hash = "sha256-X5EoRR65TE+LoaKksu5+F++IUBCPtyJXavprMFO4+iY=";
  };

  simdutf = fetchurl {
    url = "https://github.com/simdutf/simdutf/releases/download/v6.4.2/singleheader.zip";
    hash = "sha256-n+TW9RVySlXI3oj+5EY+CJChq+ImfNoTxLXSRdWAOeY=";
  };

  zlib-root = runCommand "zlib-root" { } ''
    mkdir $out
    ln -s ${zlib.dev}/include $out/include
    ln -s ${zlib}/lib $out/lib
  '';

  meta = {
    description = "Modern cross-platform Emby, Plex & Jellyfin client built with Flutter";
    homepage = "https://github.com/edde746/plezy";
    changelog = "https://github.com/edde746/plezy/releases/tag/${version}";
    mainProgram = "plezy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      mio
      miniharinn
      BatteredBunny
    ];
    platforms = lib.platforms.linux ++ [
      "aarch64-darwin"
    ];
    sourceProvenance = lib.optionals stdenv.hostPlatform.isDarwin (
      with lib.sourceTypes; [ binaryNativeCode ]
    );
  };

  linux = flutter347.buildFlutterApplication rec {
    inherit pname version src;

    # upstream targets 3.12 until its freezed 4 migration: https://github.com/edde746/plezy/blob/2.21.0/pubspec.yaml#L6-L9
    pubspecLock = lib.recursiveUpdate (lib.importJSON ./pubspec.lock.json) {
      sdks.dart = ">=3.12.0 <4.0.0";
    };

    gitHashes = lib.importJSON ./git-hashes.json;

    patches = lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      ./aarch64-linux.patch
    ];

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
      zlib
      libevdev
      jdk
    ];

    env = {
      ZLIB_ROOT = zlib-root;
      JAVA_HOME = "${jdk}/lib/openjdk";
    };

    postPatch = ''
      substituteInPlace linux/CMakeLists.txt \
        --replace-fail "URL https://github.com/simdutf/simdutf/releases/download/v6.4.2/singleheader.zip" \
                       "URL file://${simdutf}"
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "plezy";
        exec = "plezy";
        icon = "plezy";
        desktopName = "Plezy";
        comment = meta.description;
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

    passthru.updateScript = ./update.sh;

    inherit meta;
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit pname version;

    passthru.updateScript = ./update.sh;

    src = fetchurl {
      url = "https://github.com/edde746/plezy/releases/download/${version}/plezy-macos.dmg";
      hash = "sha256-jM4qKLT1szelq6yggbOLwyn8s3iN/gkpKIb1gsCionI=";
    };

    nativeBuildInputs = [
      _7zz
      makeBinaryWrapper
    ];

    sourceRoot = "Plezy.app";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/Plezy.app
      cp -r . $out/Applications/Plezy.app
      makeBinaryWrapper $out/Applications/Plezy.app/Contents/MacOS/Plezy $out/bin/plezy

      runHook postInstall
    '';

    inherit meta;
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
