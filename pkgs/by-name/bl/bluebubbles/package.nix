{
  lib,
  stdenv,
  callPackage,
  flutter347,
  fetchFromGitHub,
  fetchzip,
  autoPatchelfHook,
  webkitgtk_4_1,
  libayatana-appindicator,
  jdk,
  mpv,
}:

let
  # the plugin downloads this bundle at configure time. Keep in sync with
  # FFMPEGKIT_VERSION and FFMPEGKIT_PACKAGE in its linux/CMakeLists.txt
  ffmpeg-kit = fetchzip {
    name = "ffmpeg-kit-linux-x86_64-min-8.1.2";
    url = "https://github.com/sk3llo/ffmpeg_kit_flutter/releases/download/8.1.2-min/ffmpeg-kit-linux-x86_64-min-8.1.2.tar.gz";
    hash = "sha256-O5hDf12HfUzKxemp1IIuWTYd48rdPYEIIbUSP0gVRcU=";
    stripRoot = false;
    meta = {
      license = lib.licenses.lgpl3Only;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
in
flutter347.buildFlutterApplication rec {
  pname = "bluebubbles";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "BlueBubblesApp";
    repo = "bluebubbles-app";
    tag = "v${version}+desktop.96";
    hash = "sha256-u8rOHx6GRKu7YJStyN795QP4TB3G46VkjZn7nT1MtxY=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  customSourceBuilders.objectbox_flutter_libs = callPackage ./objectbox_flutter_libs.nix { };

  gitHashes = {
    desktop_drop = "sha256-ZvSTnZMCrA0WF+bERalxukeTnaeQiVU4g8geNeZoy3Y=";
    desktop_webview_auth = "sha256-zYROspZsKSH+VdTjsVlXQ7oS7cr9DrawYpy+BsRKX1U=";
    disable_battery_optimization = "sha256-ZvSTnZMCrA0WF+bERalxukeTnaeQiVU4g8geNeZoy3Y=";
    ffmpeg_kit_flutter_new_min = "sha256-gqLP07z3IomxnYqX8sWFw5v1WZF2CVWhU9+IuDP9sZQ=";
    firebase_dart = "sha256-jq4Y5ApGPrXcLN3gwC9NuGN/EQkl5u64iMzL8KG02Sc=";
    flat_buffers = "sha256-RRKL1im0JcSHAe/TH0PBTpcklkTRN47MJsUkrp4jZjg=";
    flutter_local_notifications_windows = "sha256-zEXiXC0+yaIRglVWe60s0sEKBDbHBnfnKjIjctori8A=";
    flutter_map = "sha256-dNpTagcCh6R4+3NzR5/THNH/5q0H4IOcPZqm/GgNlv8=";
    gesture_x_detector = "sha256-X3TiMeWV4VbDkZLVBsqXA4swVQNrZemgShUeC75dB8c=";
    permission_handler_windows = "sha256-kUF8WfnIoeoq8k0HV6k5/VoQca0e/tNuIO3pO5Ue3Ss=";
    connectivity_plus = "sha256-B4C+R5V5Qt3Ym5o1XVgMsSdVZmzfGbLWT7OCWgYikO8=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  env = lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
    FFMPEGKIT_LOCAL_DIR = "${ffmpeg-kit}/ffmpeg-kit";
  };

  buildInputs = [
    webkitgtk_4_1
    libayatana-appindicator
    jdk
    mpv
  ];

  # distributed in release tarballs under `data/flutter_assets/.env`, necessary for build and runtime
  preBuild = ''
    echo 'KLIPY_API_KEY=xTqaU4zgnNDVEgU4HkcID8ur4wPKQ5uHAcW5So5hAkXEgETvu9DSEewOG0hMuqAK' > .env
  '';

  postInstall = ''
    sed -i 's#Icon=.*/bluebubbles.png#Icon=bluebubbles#g' snap/gui/bluebubbles.desktop
    install -Dm0644 snap/gui/bluebubbles.desktop $out/share/applications/bluebubbles.desktop
    install -Dm0644 snap/gui/bluebubbles.png -t $out/share/icons/hicolor/1024x1024/apps
    install -Dm0644 flatpak/icon/128x128.png $out/share/icons/hicolor/128x128/apps/bluebubbles.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/bluebubbles/lib
  '';

  meta = {
    description = "Cross-platform iMessage client";
    homepage = "https://github.com/BlueBubblesApp/bluebubbles-app";
    mainProgram = "bluebubbles";
    license = with lib.licenses; [
      asl20 # the app
      lgpl3Only # bundled ffmpeg-kit
      unfree # bundled objectbox core library
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      zacharyweiss
    ];
  };
}
