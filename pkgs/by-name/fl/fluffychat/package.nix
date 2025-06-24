{
  lib,
  fetchFromGitHub,
  imagemagick,
  libgbm,
  libdrm,
  flutter332,
  pulseaudio,
  makeDesktopItem,
  olm,
  buildDartApplication,
  rustPlatform,
  rustc,
  wasm-pack,
  wasm-bindgen-cli_0_2_100,
  binaryen,
  which,
  bash,
  cargo,
  writableTmpDirAsHomeHook,

  targetFlutterPlatform ? "linux",
}:

let
  libwebrtcRpath = lib.makeLibraryPath [
    libgbm
    libdrm
  ];
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  dart-vodozemac = buildDartApplication rec {
    pname = "dart-vodozemac";
    version = "0-unstable-2025-06-16";

    src = fetchFromGitHub {
      owner = "famedly";
      repo = "dart-vodozemac";
      rev = "a3446206da432a3a48dedf39bb57604a376b3582";
      hash = "sha256-uRCxZ+FQpUc3iJD/kv4wBHbqdXJIhYvmCFU7kY4W8RY=";
    };

    pubspecLock = lib.importJSON ./dart-vodozemac.pubspec.lock.json;

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      sourceRoot = "${src.name}/rust";
      hash = "sha256-Iw0AkHVjR1YmPe+C0YYBTDu5FsRk/ZpaRyBilcvqm6M=";
    };

    cargoRoot = "rust";

    postPatch = ''
      cp dart/pubspec.yaml pubspec.yaml
      patchShebangs .
    '';

    nativeBuildInputs = [
      wasm-pack
      wasm-bindgen-cli_0_2_100
      binaryen
      rustc.llvmPackages.lld
      rustc
      which
      bash
      cargo
      rustPlatform.cargoSetupHook
      writableTmpDirAsHomeHook
    ];

    buildPhase = ''
      runHook preBuild

      RUST_LOG=debug packageRun flutter_rust_bridge build-web --dart-root dart --rust-root $(readlink -f rust) --release

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp rust/dart/web/pkg/vodozemac_bindings_dart* $out

      runHook postInstall
    '';

    meta = {
      description = "Library provides bindings to Olm and Megolm libraries from Dart";
      license = lib.licenses.agpl3Only;
      inherit (olm.meta) knownVulnerabilities;
    };
  };
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
      flutter_secure_storage_linux = "sha256-cFNHW7dAaX8BV7arwbn68GgkkBeiAgPfhMOAFSJWlyY=";
      flutter_web_auth_2 = "sha256-3aci73SP8eXg6++IQTQoyS+erUUuSiuXymvR32sxHFw=";
      flutter_typeahead = "sha256-ZGXbbEeSddrdZOHcXE47h3Yu3w6oV7q+ZnO6GyW7Zg8=";
    };

    inherit targetFlutterPlatform;

    meta = {
      description = "Chat with your friends (matrix client)";
      homepage = "https://fluffychat.im/";
      license = lib.licenses.agpl3Plus;
      mainProgram = "fluffychat";
      maintainers = with lib.maintainers; [
        mkg20001
        tebriel
        aleksana
      ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      knownVulnerabilities = lib.optionals (targetFlutterPlatform == "web") olm.meta.knownVulnerabilities;
    };
  }
  // lib.optionalAttrs (targetFlutterPlatform == "linux") {
    nativeBuildInputs = [ imagemagick ];

    runtimeDependencies = [ pulseaudio ];

    env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";

    desktopItem = makeDesktopItem {
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
    };

    postInstall = ''
      FAV=$out/app/fluffychat-linux/data/flutter_assets/assets/favicon.png
      ICO=$out/share/icons

      install -D $FAV $ICO/fluffychat.png
      mkdir $out/share/applications
      cp $desktopItem/share/applications/*.desktop $out/share/applications
      for size in 24 32 42 64 128 256 512; do
        D=$ICO/hicolor/''${size}x''${size}/apps
        mkdir -p $D
        magick $FAV -resize ''${size}x''${size} $D/fluffychat.png
      done

      patchelf --add-rpath ${libwebrtcRpath} $out/app/fluffychat-linux/lib/libwebrtc.so
    '';
  }
  // lib.optionalAttrs (targetFlutterPlatform == "web") {
    flutterBuildFlags = [
      "--dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/"
      "--release"
      "--source-maps"
    ];

    preBuild = ''
      cp ${dart-vodozemac}/* ./assets/vodozemac/
    '';
  }
)
