{
  lib,
  flutter341,
  stdenv,
  fetchFromGitHub,
  fetchzip,

  webkitgtk_4_1,
  mimalloc,
  keybinder3,

  mpv-unwrapped,
  libdovi,
  libdvdcss,
  libunwind,

  libgbm,
  libdrm,
}:

let
  libwebrtcRpath = lib.makeLibraryPath [
    libgbm
    libdrm
  ];
  libwebrtc = fetchzip {
    url = "https://github.com/flutter-webrtc/flutter-webrtc/releases/download/v1.2.1/libwebrtc.zip";
    hash = "sha256-i4LRG44f//SDIOl072yZavkYoTZdiydPZndeOm6/fBM=";
  };
in
flutter341.buildFlutterApplication (finalAttrs: {
  pname = "commet-chat";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "commetchat";
    repo = "commet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S3E1Yn4AnLkYK08rlFeIkdrBbdS90bjOywkdleUZSGs=";
    fetchSubmodules = true;
    leaveDotGit = true;

    # For the git hash property in about page
    postFetch = ''
      cd $out
      git rev-parse HEAD | head -c 7 > $out/GIT_HASH
      find $out -name .git -print0 | xargs -0 rm -rf
    '';
  };
  strictDeps = true;
  sourceRoot = "${finalAttrs.src.name}/commet";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    calendar_view = "sha256-tGAMK89VsgqfKQy+t8x5zl6dbQEf5h4HxSUR8crB1oM=";
    desktop_webview_window = "sha256-EOh5QoOuAxiYn0IcdxY7taN2Twu8GshY9zAoGCztPnA=";
    dynamic_color = "sha256-4zSTiXplkBjtPtzssj3VaHTVo9YlYKNTMLgBIM5MMe4=";
    flutter_highlighter = "sha256-Y84Besir3gu1RnQt9YoE0GyIJLLZ6H0Kki/Wf6z6QMg=";
    flutter_html = "sha256-576KYoYB4sZeavcAS8V5rjDG9hezYlN2Q4zlyvBOouw=";
    flutter_local_notifications = "sha256-AgvvFoJgos/gsTwcLGX/CxbHauWiH3OHksqtF0Dauuw=";
    flutter_local_notifications_linux = "sha256-AgvvFoJgos/gsTwcLGX/CxbHauWiH3OHksqtF0Dauuw=";
    markdown = "sha256-2rEMNJM9Vy7LrFLt30/Z3pyqERTYJei9D3mgOAAvVPg=";
    matrix = "sha256-YrArfC9AMWzFYcFkeWJMeFgIo1bJbmkTbeZfcYYA1zA=";
    matrix_dart_sdk_drift_db = "sha256-t4a61O0nk9We0s4+cQB30H05giKi8IE3srPza57Ii94=";
    receive_intent = "sha256-wGIOZRH4O3a44I8zG5Q1hCwn4SMuTWB7i9wtGSLZWeQ=";
    signal_sticker_api = "sha256-VdEE3Bt8gpfUpxxYSz5319YEL49Eh+loO+ZipI1DoyA=";
    starfield = "sha256-ebVRyVkyLfHCC6EBmx5evXL1U71S3tgCMo1yLWlIcw4=";
  };

  buildInputs = [
    webkitgtk_4_1
    mimalloc
    keybinder3

    mpv-unwrapped
    libdovi
    libdvdcss
    libunwind
  ]
  ++ mpv-unwrapped.buildInputs;

  env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";
  env.COMMET_PROD = 1;

  targetFlutterPlatform = "linux";

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

  # The original codegen.dart hardcodes flutter calls inside, so the patch basically rewrites the codegen script forcing nix.
  patches = [
    ./fix-hardcoded-flutter-cmd.patch
  ];

  flutterBuildFlags = [
    "--dart-define=BUILD_MODE=release"
    "--dart-define=PLATFORM=linux"
    "--dart-define=VERSION_TAG=v${finalAttrs.version}"
    "--dart-define=BUILD_DETAIL=${stdenv.hostPlatform.system}"
  ];

  preBuild = ''
    export flutterBuildFlags="$flutterBuildFlags --dart-define=GIT_HASH=$(cat ../GIT_HASH)"

    packageRun intl_utils -e generate
    dart run --packages=.dart_tool/package_config.json scripts/codegen.dart
    packageRun intl_translation -e generate_from_arb \
      --sources-list-file /build/source/commet/lib/generated/l10n/sources_list_file.txt \
      --translations-list-file /build/source/commet/lib/generated/l10n/arb_list_file.txt \
      --output-dir=lib/generated/l10n
    packageRun build_runner build --delete-conflicting-outputs
  '';

  extraWrapProgramArgs = "--suffix LD_LIBRARY_PATH : $out/app/commet-chat/lib";

  postInstall = ''
    mkdir -p $out/share/applications
    install -Dm644 \
      linux/debian/usr/share/applications/chat.commet.commetapp.desktop \
      $out/share/applications/
    substituteInPlace $out/share/applications/chat.commet.commetapp.desktop \
      --replace-fail "/usr/lib/chat.commet.commetapp/commet" "commet"

    mkdir -p $out/share/icons
    cp -r linux/debian/usr/share/icons/hicolor $out/share/icons/hicolor

    patchelf --add-rpath ${libwebrtcRpath} $out/app/commet-chat/lib/libwebrtc.so
  '';

  meta = {
    homepage = "https://commet.chat";
    description = "Client for Matrix focused on providing a feature rich experience while maintaining a simple interface";
    platforms = lib.platforms.linux;
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ckgxrg ];
    mainProgram = "commet";
  };
})
