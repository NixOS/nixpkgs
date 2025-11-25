{
  lib,
  stdenv,
  flutter335,
  fetchFromGitHub,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  mpv,
  sqlite,
  alsa-lib,
  libepoxy,
  libpulseaudio,
  libGL,
  libx11,
  libgbm,
  libdrm,
}:
let
  # MDK SDK required by fvp plugin
  mdk-sdk = fetchurl {
    url = "https://sourceforge.net/projects/mdk-sdk/files/nightly/mdk-sdk-linux-x64.tar.xz";
    hash = "sha256-eFfcMNgjns89BS3LxJ0Ts1qnaQLn92hrKxkXeAsJ1Z4=";
  };

  # mimalloc required by media_kit_libs_linux
  mimalloc = fetchurl {
    url = "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.2.tar.gz";
    hash = "sha256-Kxv/b3F/lyXHC/jXnkeG2hPeiicAWeS6C90mKue+Rus=";
  };
in
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
    makeBinaryWrapper # Required for wrapProgram
  ];

  buildInputs = [
    mpv
    sqlite
    alsa-lib
    libepoxy
    libpulseaudio
    libGL
    libx11
    libgbm
    libdrm
  ];

  # Git dependencies from pubspec.lock.json
  gitHashes =
    let
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

    media_kit_libs_linux =
      { version, src, ... }:
      stdenv.mkDerivation {
        pname = "media_kit_libs_linux";
        inherit version src;
        inherit (src) passthru;

        # Patch CMakeLists.txt to use our pre-downloaded mimalloc instead of downloading it
        postPatch = ''
          # Replace the download_and_verify call with a copy command using sed
          sed -i '/download_and_verify(/,/)/{
            /download_and_verify(/c\  execute_process(COMMAND ''${CMAKE_COMMAND} -E copy ${mimalloc} ''${MIMALLOC_ARCHIVE})
            /MIMALLOC_URL/d
            /MIMALLOC_MD5/d
            /MIMALLOC_ARCHIVE/d
            /^  )$/d
          }' libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
        '';

        installPhase = ''
          runHook preInstall

          mkdir $out
          cp -r ./* $out/

          runHook postInstall
        '';
      };

    fvp =
      { version, src, ... }:
      stdenv.mkDerivation {
        pname = "fvp";
        inherit version src;
        inherit (src) passthru;

        postPatch = ''
          # Pre-provision the MDK SDK by extracting it directly to avoid downloading during build
          mkdir -p linux
          tar -xf ${mdk-sdk} -C linux
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
    # Install SVG icon
    install -Dm644 icons/fladder_icon.svg \
      $out/share/icons/hicolor/scalable/apps/fladder.svg
  '';

  # Wrap the executable to find libraries loaded at runtime (dlopen)
  postFixup = ''
    wrapProgram $out/bin/Fladder \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libpulseaudio
          libepoxy
          alsa-lib
          mpv
          sqlite
          libGL
          libx11
          libgbm
          libdrm
        ]
      }
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
