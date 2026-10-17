{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter344,
  imagemagick,
  webkitgtk_4_1,
  copyDesktopItems,
  makeDesktopItem,
  callPackage,
  vodozemac-wasm ? callPackage ./vodozemac-wasm.nix { flutter = flutter344; },
  targetFlutterPlatform ? "linux",
}:

let
  pubspecLock = lib.importJSON ./pubspec.lock.json;
in
flutter344.buildFlutterApplication (
  rec {
    pname = "fluffychat-${targetFlutterPlatform}";
    version = "2.9.4";

    src = fetchFromGitHub {
      owner = "krille-chan";
      repo = "fluffychat";
      tag = "v${version}";
      hash = "sha256-nL0zyOg3pXbgg9hkXzq6B2igmUQ5jkTVlVi7k8TLggA=";
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
      cp -r ${vodozemac-wasm}/* ./assets/vodozemac/
    '';
  }
)
