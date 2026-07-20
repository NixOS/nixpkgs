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
  makeDesktopItem,
  pkg-config,
  gst_all_1,
  keybinder3,
  libsecret,
  patchelf,

  callPackage,
  # A web version will be prepared later
  #vodozemac-wasm ? callPackage ./vodozemac-wasm.nix { flutter = flutter341; },
  targetFlutterPlatform ? "linux",
}:
let
    libwebrtcRpath = lib.makeLibraryPath [
      libgbm
      libdrm
    ];
    libwebrtc = fetchzip {
      url = "https://github.com/flutter-webrtc/flutter-webrtc/releases/download/v1.4.0/libwebrtc.zip";
      sha256 = "sha256-OvqUF6RuytDorJE+C58EnIxPHfcphs8iPiPjt7SDrU0=";
    };
in
flutter341.buildFlutterApplication (
  finalAttrs: {
    pname = "extera-next";
    version = "unstable-2026-07-17";
    strictDeps = true;
    # flutter.buildApplication does not support this parameter; the build fails with an error: > ln: failed to create symbolic link 'pubspec.lock' -> '': No such file or directory
    # __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "ExteraApp";
      repo = "Extera";
      rev = "33a075b212f84e37b6e9587e4d465088c23131ae";
      sha256 = "sha256-u1eTuzhzHae0P3VK8KOo87cIvu++a4Hj3w6r9nWNcvY=";
    };
    gitHashes = {
      "android_system_font" = "sha256-mzbZ+joDw9E0PTFwqehiynMcWxAG5W5H+BZrWbpovBg=";
      "flutter_typeahead" = "sha256-ZGXbbEeSddrdZOHcXE47h3Yu3w6oV7q+ZnO6GyW7Zg8=";
      "matrix" = "sha256-3/CVjZgj7opQoHnQy4U7Az6DFjy+gZCawCkB+1Tv2Sg=";
    };

    patches = [
      ./fix-matrix.patch
    ];

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    inherit targetFlutterPlatform;

    flutterBuildFlags = [
      # Required since v2.4.0
      "--enable-experiment=dot-shorthands"
    ];

    meta = {
      description = "A feature-rich [matrix] client made in Flutter";
      homepage = "https://extera.xyz/";
      license = lib.licenses.agpl3Plus;
      maintainers = with lib.maintainers; [ mate-linux ];
      badPlatforms = lib.platforms.darwin;
      platforms = lib.platforms.linux;
    }
    // lib.optionalAttrs (targetFlutterPlatform == "linux") {
      mainProgram = "extera-next";
    };
  }
  // lib.optionalAttrs (targetFlutterPlatform == "linux") {
    nativeBuildInputs = [
      pkg-config
      imagemagick
      patchelf
    ];

    buildInputs = [
      webkitgtk_4_1
      libsecret
      keybinder3
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
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
            mkdir -p $out
            cp -r ./* $out/
            runHook postInstall
          '';

        };
    };

    postInstall = ''
      FAV=$out/app/extera-next/data/flutter_assets/assets/favicon.png

      for size in 24 32 42 64 128 256 512; do
        D=$out/share/icons/hicolor/''${size}x''${size}/apps
        mkdir -p $D
        magick $FAV -resize ''${size}x''${size} $D/extera-next.png
      done

      patchelf --add-rpath ${libwebrtcRpath} $out/app/extera-next/lib/libwebrtc.so
      mv $out/bin/extera_next $out/bin/extera-next
    '';
  }
  #// lib.optionalAttrs (targetFlutterPlatform == "web") {
  #  preBuild = ''
  #    cp -r ${vodozemac-wasm}/* ./assets/vodozemac/
  #  '';
  #}
)
