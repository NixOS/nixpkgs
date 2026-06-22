{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  libgbm,
  libdrm,
  flutter344,
  pulseaudio,
  webkitgtk_4_1,
  copyDesktopItems,
  makeDesktopItem,
  callPackage,
  vodozemac-wasm ? callPackage ./vodozemac-wasm.nix { flutter = flutter344; },
  targetFlutterPlatform ? "linux",
}:

let
  libwebrtcRpath = lib.makeLibraryPath [
    libgbm
    libdrm
  ];
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  libwebrtc_version = "m144.7559.09";
  libwebrtc =
    {
      x86_64-linux = fetchzip {
        url = "https://github.com/webrtc-sdk/libwebrtc/releases/download/libwebrtc.${libwebrtc_version}/libwebrtc-linux-x64-release.zip";
        sha256 = "sha256-uzS07voCGM1zs663UalYpb8pWiYpkrKMxKt/wB4rcB4=";
      };
      aarch64-linux = fetchzip {
        url = "https://github.com/webrtc-sdk/libwebrtc/releases/download/libwebrtc.${libwebrtc_version}/libwebrtc-linux-arm64-release.zip";
        sha256 = "sha256-nMMU/HrCN4zSB4vO1O4TfJRBtK87OX+zYbxZRq8Q4Us=";
      };
    }
    .${stdenv.hostPlatform.system};
in
flutter344.buildFlutterApplication (
  rec {
    pname = "fluffychat-${targetFlutterPlatform}";
    version = "2.7.2";

    src = fetchFromGitHub {
      owner = "krille-chan";
      repo = "fluffychat";
      tag = "v${version}";
      hash = "sha256-faBXPpmcVa2Bes2TITWoHLyFlIAztbI99W7TjdbFxrU=";
    };

    inherit pubspecLock;

    inherit targetFlutterPlatform;

    flutterBuildFlags = [
      # Required since v2.4.0
      "--enable-experiment=dot-shorthands"
    ];

    meta = {
      description = "Chat with your friends (matrix client)";
      homepage = "https://fluffychat.im/";
      license = lib.licenses.agpl3Plus;
      maintainers = with lib.maintainers; [
        mkg20001
        tebriel
        aleksana
      ];
      badPlatforms = lib.platforms.darwin;
    }
    // lib.optionalAttrs (targetFlutterPlatform == "linux") {
      mainProgram = "fluffychat";
    };
  }
  // lib.optionalAttrs (targetFlutterPlatform == "linux") {
    nativeBuildInputs = [
      copyDesktopItems
      webkitgtk_4_1
    ];

    runtimeDependencies = [ pulseaudio ];

    env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";
    env.CXXFLAGS = "-include cstdint";

    desktopItems = [
      (makeDesktopItem {
        name = "Fluffychat";
        exec = "fluffychat";
        icon = "fluffychat";
        desktopName = "Fluffychat";
        genericName = "Chat with your friends (matrix client)";
        categories = [
          "Chat"
          "Network"
          "InstantMessaging"
        ];
        startupWMClass = "fluffychat";
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
            # Since we directly supply the binary distribution of libwebrtc instead of letting the builder download it we need to check that we still provide the correct version.
            # nixpkgs forbids import from derivation, so we cannot simply read the contents to fetch the correct version
            if ! grep -q "binary_version = libwebrtc.${libwebrtc_version}" third_party/libwebrtc_version.ini; then
              echo -en "\nWrong libwebrtc version is in use!\n\t'libwebrtc.${libwebrtc_version}' was supplied, but cannot be found in 'third_party/libwebrtc_version.ini'.\nflutter_webrtc expects the following version:\n\t"
              grep "binary_version" third_party/libwebrtc_version.ini; echo
              false # triggers the build failure
            fi
            substituteInPlace third_party/CMakeLists.txt \
              --replace-fail "\''${CMAKE_CURRENT_LIST_DIR}/downloads/\''${LIBWEBRTC_ASSET}.zip" ${libwebrtc}
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
      ICO=$out/share/icons

      mkdir -p $ICO/hicolor/scalable/apps
      cp $src/assets/logo/vector/logo_standalone.svg $ICO/hicolor/scalable/apps/fluffychat.png

      patchelf --add-rpath ${libwebrtcRpath} $out/app/fluffychat-linux/lib/libwebrtc.so
    '';
  }
  // lib.optionalAttrs (targetFlutterPlatform == "web") {
    preBuild = ''
      cp -r ${vodozemac-wasm}/* ./assets/vodozemac/
    '';
  }
)
