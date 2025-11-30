{
  lib,
  stdenv,
  flutter335,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  mpv-unwrapped,
  sqlite,
  alsa-lib,
  libepoxy,
  callPackage,
}:

flutter335.buildFlutterApplication rec {
  pname = "fladder";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    tag = "v${version}";
    hash = "sha256-Rpnf4fYsChbCsezBtmqQ8xkaj6HmfnDPvZLSZjPEPJ0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    mpv-unwrapped
    sqlite
    alsa-lib
    libepoxy
  ];

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
    media_kit_libs_linux = callPackage ./media_kit_libs_linux_donutware.nix {
      miMallocVersion = "2.1.2";
      miMallocHash = "sha256-Kxv/b3F/lyXHC/jXnkeG2hPeiicAWeS6C90mKue+Rus=";
    };

    fvp = callPackage ./fvp.nix {
      fvpVersion = pubspecLock.packages.fvp.version;
      fvpHash = "sha256-GaHaNYGUANhosX1Aq7ehGeGGwCxu3Ar1NxgTSyPhnhA=";
    };
  };

  postInstall = ''
    # Install SVG icon
    install -Dm644 icons/fladder_icon.svg \
      $out/share/icons/hicolor/scalable/apps/fladder.svg
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
    maintainers = with lib.maintainers; [ vikingnope ];
    mainProgram = "fladder";
    platforms = lib.platforms.linux;
  };
}
