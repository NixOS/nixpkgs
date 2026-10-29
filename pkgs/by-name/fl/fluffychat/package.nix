{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter347,
  imagemagick,
  webkitgtk_4_1,
  copyDesktopItems,
  makeDesktopItem,
  callPackage,
  vodozemac-wasm ? callPackage ./vodozemac-wasm.nix { flutter = flutter347; },
  targetFlutterPlatform ? "linux",
}:

let
  pubspecLock = lib.importJSON ./pubspec.lock.json;
in
flutter347.buildFlutterApplication (
  finalAttrs:
  rec {
    pname = "fluffychat-${targetFlutterPlatform}";
    version = "2.11.1";

    src = fetchFromGitHub {
      owner = "krille-chan";
      repo = "fluffychat";
      tag = "v${version}";
      hash = "sha256-l0NyKVjZvbvQNriouAA4FwhLD64L5OE1RJssqPRXcto=";
    };

    inherit pubspecLock;

    inherit targetFlutterPlatform;

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
      imagemagick
      copyDesktopItems
      webkitgtk_4_1
    ];

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

    customSourceBuilders = lib.optionalAttrs (stdenv.hostPlatform.system == "aarch64-linux") {
      native_toolchain_cmake =
        { version, src, ... }:
        stdenv.mkDerivation {
          pname = "native_toolchain_cmake";
          inherit version src;
          inherit (src) passthru;

          postPatch = ''
            substituteInPlace cmake/aarch64-linux-gnu.toolchain.cmake \
              --replace-fail "aarch64-linux-gnu-gcc" "gcc"

            substituteInPlace cmake/aarch64-linux-gnu.toolchain.cmake \
              --replace-fail "aarch64-linux-gnu-g++" "g++"
          '';

          installPhase = ''
            runHook preInstall

            mkdir $out
            cp -r ./* $out/

            runHook postInstall
          '';
        };
    };

    postPatch = ''
      substituteInPlace linux/CMakeLists.txt \
        --replace-fail \
        "PRIVATE -Wall -Werror" \
        "PRIVATE -Wall"
    '';

    postInstall = ''
      ICO=$out/share/icons

      mkdir -p $ICO/hicolor/scalable/apps
      cp $src/assets/logo/vector/logo_standalone.svg $ICO/hicolor/scalable/apps/fluffychat.png
    '';
  }
  // lib.optionalAttrs (targetFlutterPlatform == "web") {
    preBuild = ''
      cp -r ${vodozemac-wasm} -T ./assets/vodozemac/${finalAttrs.finalPackage.pubspecLock.dependencyVersions.flutter_vodozemac}
    '';
  }
)
