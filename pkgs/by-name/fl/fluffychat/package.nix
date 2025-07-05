{
  lib,
  fetchFromGitHub,
  imagemagick,
  libgbm,
  libdrm,
  flutter332,
  pulseaudio,
  copyDesktopItems,
  makeDesktopItem,

  callPackage,
  vodozemac-wasm ? callPackage ./vodozemac-wasm.nix { flutter = flutter332; },

  targetFlutterPlatform ? "linux",
}:

let
  libwebrtcRpath = lib.makeLibraryPath [
    libgbm
    libdrm
  ];
  pubspecLock = lib.importJSON ./pubspec.lock.json;
in
flutter332.buildFlutterApplication (
  rec {
    pname = "fluffychat-${targetFlutterPlatform}";
    version = "2.0.0";

    src = fetchFromGitHub {
      owner = "krille-chan";
      repo = "fluffychat";
      tag = "v${version}";
      hash = "sha256-fFc6nIVQUY9OiGkEc7jrzXnBQPDWC5x5A4/XHUhu6hs=";
    };

    inherit pubspecLock;

    gitHashes = {
      flutter_web_auth_2 = "sha256-3aci73SP8eXg6++IQTQoyS+erUUuSiuXymvR32sxHFw=";
      flutter_typeahead = "sha256-ZGXbbEeSddrdZOHcXE47h3Yu3w6oV7q+ZnO6GyW7Zg8=";
      flutter_secure_storage_linux = "sha256-cFNHW7dAaX8BV7arwbn68GgkkBeiAgPfhMOAFSJWlyY=";
    };

    inherit targetFlutterPlatform;

    meta =
      {
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
    ];

    runtimeDependencies = [ pulseaudio ];

    env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";

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
      })
    ];

    postInstall = ''
      FAV=$out/app/fluffychat-linux/data/flutter_assets/assets/favicon.png
      ICO=$out/share/icons

      for size in 24 32 42 64 128 256 512; do
        D=$ICO/hicolor/''${size}x''${size}/apps
        mkdir -p $D
        magick $FAV -resize ''${size}x''${size} $D/fluffychat.png
      done

      patchelf --add-rpath ${libwebrtcRpath} $out/app/fluffychat-linux/lib/libwebrtc.so
    '';
  }
  // lib.optionalAttrs (targetFlutterPlatform == "web") {
    preBuild = ''
      cp -r ${vodozemac-wasm}/* ./assets/vodozemac/
    '';
  }
)
