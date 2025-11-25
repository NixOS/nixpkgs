{
  lib,
  stdenv,
  flutter335,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  mpv-unwrapped,
  sqlite,
}:
flutter335.buildFlutterApplication {
  pname = "fladder";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    rev = "v0.8.0";
    hash = "sha256-Rpnf4fYsChbCsezBtmqQ8xkaj6HmfnDPvZLSZjPEPJ0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    mpv-unwrapped
    sqlite
  ];

  # Git dependencies from pubspec.lock.json
  # These hashes will be filled in automatically during the build process
  # When you first run nix-build, it will fail with the expected hash for each dependency
  # Copy those hashes here to fix the build
  gitHashes =
    let
      # Most dependencies come from DonutWare/media-kit with shared hash
      media_kit-hash = "sha256-Vw/XMFa4TBHS69fJcnCOKfEuTCuZ+Yqdz/WPMLIXQEk=";
    in
    {
      media_kit = media_kit-hash;
      media_kit_video = media_kit-hash;
      media_kit_libs_linux = media_kit-hash;
      media_kit_libs_video = media_kit-hash;
      media_kit_libs_android_video = media_kit-hash;
      media_kit_libs_ios_video = media_kit-hash;
      media_kit_libs_macos_video = media_kit-hash;
      media_kit_libs_windows_video = media_kit-hash;
    };

  customSourceBuilders = {
    volume_controller =
      { version, src, ... }:
      stdenv.mkDerivation {
        pname = "volume_controller";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          substituteInPlace linux/CMakeLists.txt \
            --replace-fail '# ALSA dependency for volume control' 'find_package(PkgConfig REQUIRED)' \
            --replace-fail 'find_package(ALSA REQUIRED)' 'pkg_check_modules(ALSA REQUIRED alsa)'
        '';

        installPhase = ''
          runHook preInstall

          mkdir $out
          cp -r ./* $out/

          runHook postInstall
        '';
      };
  };

  postInstall = ''
    # Install icon
    for size in 16 32 48 64 128 256 512; do
      install -Dm644 assets/icon/icon-\''${size}x\''${size}.png \
        $out/share/icons/hicolor/\''${size}x\''${size}/apps/fladder.png
    done
    
    # Fallback to a main icon if specific sizes don't exist
    install -Dm644 assets/icon/icon.png \
      $out/share/icons/hicolor/256x256/apps/fladder.png || true
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "fladder";
      desktopName = "Fladder";
      genericName = "Jellyfin Client";
      exec = "fladder";
      icon = "fladder";
      comment = "A simple cross-platform Jellyfin client";
      categories = [
        "AudioVideo"
        "Video"
        "Player"
      ];
    })
  ];

  meta = {
    description = "Simple cross-platform Jellyfin client built with Flutter";
    homepage = "https://github.com/DonutWare/Fladder";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "fladder";
    platforms = lib.platforms.linux;
  };
}
