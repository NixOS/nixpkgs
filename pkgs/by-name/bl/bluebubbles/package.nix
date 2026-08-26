{
  lib,
  callPackage,
  flutter329,
  fetchFromGitHub,
  autoPatchelfHook,
  webkitgtk_4_1,
  libnotify,
  libayatana-appindicator,
  jdk,
  mpv,
}:

flutter329.buildFlutterApplication rec {
  pname = "bluebubbles";
  version = "1.15.7";

  src = fetchFromGitHub {
    owner = "BlueBubblesApp";
    repo = "bluebubbles-app";
    tag = "v${version}+76-desktop";
    hash = "sha256-KmIoJHQAF4DQQ78SJ5Vra7ubfvqTjmK4lf8tGJDJNTs=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  customSourceBuilders.objectbox_flutter_libs = callPackage ./objectbox_flutter_libs.nix { };

  gitHashes = {
    desktop_webview_auth = "sha256-G6xrC6Jz3kYAysHI6w/8ahzXTvX7k6QW3GB3b8Uh+RQ=";
    disable_battery_optimization = "sha256-IsfclmbdLvju+0VWElFz9brdVntRESFB+PF8UPJBL2E=";
    firebase_dart = "sha256-jq4Y5ApGPrXcLN3gwC9NuGN/EQkl5u64iMzL8KG02Sc=";
    gesture_x_detector = "sha256-H3OJxDhESWwnpRky9jS9RIBiZ7gSqWQ/j0x/1VvRb5M=";
    local_notifier = "sha256-OvJKZXa2qmEgKV0Z3Ptdg0e/abWFAmH0z/DZFgW2TIQ=";
    permission_handler_windows = "sha256-9h0wEOgY6gtqaSyH9x2fbvH8Y0EfoVs/qNqwwI5d18k=";
    video_thumbnail = "sha256-7IbKg6bBA5D8ODwMNwJqIohTCbAox56TMgoI07CbrPw=";
    flutter_map = "sha256-JsVh7wwyehhAkE+TIvThQ8iYx7icY76qm2Pwf/k0Z7M=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    webkitgtk_4_1
    libnotify
    libayatana-appindicator
    jdk
    mpv
  ];

  # distributed in release tarballs under `data/flutter_assets/.env`, necessary for build and runtime
  preBuild = ''
    echo 'TENOR_API_KEY=AIzaSyAQwUlgo8sF5FBuIiampkfzaGgVPMglcGk' > .env
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
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      zacharyweiss
    ];
  };
}
