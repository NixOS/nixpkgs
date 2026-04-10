{
  lib,
  stdenv,
  stdenvNoCC,
  flutter338,
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
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "edde746";
    repo = "plezy";
    tag = version;
    hash = "sha256-9bB9L9f2s0i2xF4JIe4vlEpt/bmF1gf3gxcoHdCrYqc=";
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
    description = "Modern cross-platform Plex client built with Flutter";
    homepage = "https://github.com/edde746/plezy";
    mainProgram = "plezy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      mio
      miniharinn
    ];
    platforms = lib.platforms.linux ++ [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = lib.optionals stdenv.hostPlatform.isDarwin (
      with lib.sourceTypes; [ binaryNativeCode ]
    );
  };

  linux = flutter338.buildFlutterApplication rec {
    inherit pname version src;

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
      hash = "sha256-a3LvwWZvLPD7yKKbC+oYXSgoHXUS+mOojzfDyW7/QOE=";
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
