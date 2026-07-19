{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  imagemagick,
  libgbm,
  libdrm,
  flutter341,
  pulseaudio,
  webkitgtk_4_1,
  copyDesktopItems,
  makeDesktopItem,

  callPackage,
  vodozemac-wasm ? callPackage ./vodozemac-wasm.nix { flutter = flutter341; },

  targetFlutterPlatform ? "linux",
  gst_all_1,
  keybinder3,
}:

let
  libwebrtcRpath = lib.makeLibraryPath [
    libgbm
    libdrm
  ];
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  libwebrtc = fetchzip {
    url = "https://github.com/flutter-webrtc/flutter-webrtc/releases/download/v1.4.0/libwebrtc.zip";
    sha256 = "sha256-OvqUF6RuytDorJE+C58EnIxPHfcphs8iPiPjt7SDrU0=";
  };
in
flutter341.buildFlutterApplication (
  rec {
    pname = "extera-next";
    version = "unstable-2026-07-17";

    src = fetchFromGitHub {
      owner = "ExteraApp";
      repo = "Extera";
      rev = "33a075b212f84e37b6e9587e4d465088c23131ae";
      sha256 = "sha256-u1eTuzhzHae0P3VK8KOo87cIvu++a4Hj3w6r9nWNcvY=";
    };

    inherit pubspecLock;

    patches = [
      ./fix-matrix.patch
    ];

    gitHashes = {
      "android_system_font" = "sha256-mzbZ+joDw9E0PTFwqehiynMcWxAG5W5H+BZrWbpovBg=";
      "flutter_typeahead" = "sha256-ZGXbbEeSddrdZOHcXE47h3Yu3w6oV7q+ZnO6GyW7Zg8=";
      "matrix" = "sha256-3/CVjZgj7opQoHnQy4U7Az6DFjy+gZCawCkB+1Tv2Sg=";
    };

    inherit targetFlutterPlatform;

    flutterBuildFlags = [
      # Required since v2.4.0
      "--enable-experiment=dot-shorthands"
    ];

    meta = {
      description = "A feature-rich [matrix] client made in Flutter";
      homepage = "https://extera.xyz/";
      license = lib.licenses.agpl3Plus;
      maintainers = with lib.maintainers; [
        MATE-linux
      ];
      badPlatforms = lib.platforms.darwin;
      platforms = lib.platforms.linux;
    }
    // lib.optionalAttrs (targetFlutterPlatform == "linux") {
      mainProgram = "extera-next";
    };
  }
  // lib.optionalAttrs (targetFlutterPlatform == "linux") {
    nativeBuildInputs = [
      imagemagick
      copyDesktopItems
      webkitgtk_4_1
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      keybinder3
    ];

    runtimeDependencies = [ pulseaudio ];

    env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";

    desktopItems = [
      (makeDesktopItem {
        name = "Extera Next";
        exec = "extera-next";
        icon = "extera-next";
        desktopName = "Extera Next";
        genericName = "A feature-rich [matrix] client made in Flutter";
        categories = [
          "Chat"
          "Network"
          "InstantMessaging"
        ];
        startupWMClass = "extera-next";
      })
    ];

    customSourceBuilders = {
      flutter_webrtc =
        { version, src, ... }:
        stdenv.mkDerivation {
          pname = "flutter_webrtc";
          inherit version src;
          inherit (src) passthru;

          postPatch = ''
            substituteInPlace third_party/CMakeLists.txt \
              --replace-fail "\''${CMAKE_CURRENT_LIST_DIR}/downloads/libwebrtc.zip" ${libwebrtc}
              ln -s ${libwebrtc} third_party/libwebrtc
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
      FAV=$out/app/extera-next/data/flutter_assets/assets/favicon.png
      ICO=$out/share/icons

      for size in 24 32 42 64 128 256 512; do
        D=$ICO/hicolor/''${size}x''${size}/apps
        mkdir -p $D
        magick $FAV -resize ''${size}x''${size} $D/extera-next.png
      done

      patchelf --add-rpath ${libwebrtcRpath} $out/app/extera-next/lib/libwebrtc.so
    '';
  }
  // lib.optionalAttrs (targetFlutterPlatform == "web") {
    preBuild = ''
      cp -r ${vodozemac-wasm}/* ./assets/vodozemac/
    '';
  }
)
