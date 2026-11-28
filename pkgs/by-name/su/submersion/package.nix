{
  lib,
  callPackage,
  flutter347,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  pkg-config,
  glib,
  libsecret,
  webkitgtk_4_1,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter347.buildFlutterApplication (finalAttrs: {
  pname = "submersion";
  version = "1.8.5.9757";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "submersion-app";
    repo = "submersion";
    tag = "v${finalAttrs.version}";
    # libdivecomputer is vendored as a git submodule
    fetchSubmodules = true;
    hash = "sha256-woS91d62j0RfpdCobihSr4I016XVCqSSV5tRIHQVm6Y=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # Under `__structuredAttrs = true`, passAsFile leaves pubspecLockFilePath empty
  env.pubspecLockFilePath = "${./pubspec.lock.json}";

  customSourceBuilders = {
    # Pulled in by flutter_map_tile_caching
    objectbox_flutter_libs = callPackage ./objectbox_flutter_libs.nix { };
    # Its build hook downloads ONNX Runtime
    submersion_vision = callPackage ./submersion_vision.nix { };
  };

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook # prebuilt libobjectbox.so
    pkg-config
  ];

  buildInputs = [
    glib
    libsecret
    webkitgtk_4_1
  ];

  preBuild = ''
    # Under `__structuredAttrs = true`, the builder expands only the first
    # element of the flutterBuildFlags array: join all flags into it
    flutterBuildFlags=("''${flutterBuildFlags[*]}")

    # Generated sources (drift, riverpod, json_serializable) are not committed
    packageRun build_runner build --delete-conflicting-outputs
  '';

  flutterBuildFlags = [
    # Any channel other than "github" disables the in-app updater
    "--dart-define=UPDATE_CHANNEL=snapstore"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "app.submersion";
      exec = "submersion %U";
      icon = "app.submersion";
      desktopName = "Submersion";
      genericName = "Dive Log";
      comment = finalAttrs.meta.description;
      categories = [
        "Science"
        "Education"
        "Utility"
      ];
      keywords = [
        "dive"
        "diving"
        "scuba"
        "divelog"
        "logbook"
      ];
      startupWMClass = "submersion";
    })
  ];

  # objectbox dlopen()s libobjectbox.so by name
  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/submersion/lib
  '';

  postInstall = ''
    install -Dm644 assets/icon/icon.png $out/share/icons/hicolor/1024x1024/apps/app.submersion.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (
        (gitUpdater { rev-prefix = "v"; })
        // {
          supportedFeatures = [ ];
        }
      )
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "submersion.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "Open-source dive logging application for scuba divers";
    homepage = "https://submersion.app";
    changelog = "https://github.com/submersion-app/submersion/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus # the app
      unfree # bundled objectbox core library
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # objectbox-c, sqlcipher
    ];
    maintainers = with lib.maintainers; [ fraioveio ];
    mainProgram = "submersion";
    # aarch64-linux builds, but no text is rendered at runtime (tested on Asahi)
    platforms = [ "x86_64-linux" ];
  };
})
