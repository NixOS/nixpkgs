{
  lib,
  flutter327,
  fetchFromGitHub,
  autoPatchelfHook,
  webkitgtk_4_1,
  libnotify,
  libayatana-appindicator,
  jdk,
  mpv,
}:

flutter327.buildFlutterApplication rec {
  pname = "bluebubbles";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "BlueBubblesApp";
    repo = "bluebubbles-app";
    tag = "v${version}+73-desktop";
    hash = "sha256-+JCj4EuwFbzE4u+7iJ+v9FQuLVt1tozwBufw+eL5usk=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    desktop_webview_auth = "sha256-n3lvYFUzm/1sCwQBJ3Ovup4Mq7lqGJ17ktk3TJrHhKE=";
    disable_battery_optimization = "sha256-IsfclmbdLvju+0VWElFz9brdVntRESFB+PF8UPJBL2E=";
    firebase_dart = "sha256-jq4Y5ApGPrXcLN3gwC9NuGN/EQkl5u64iMzL8KG02Sc=";
    gesture_x_detector = "sha256-H3OJxDhESWwnpRky9jS9RIBiZ7gSqWQ/j0x/1VvRb5M=";
    local_notifier = "sha256-0vajd2XNGpV9aqywbCUvDC2SLjwxh1LmshTa5yttQUI=";
    permission_handler_windows = "sha256-9h0wEOgY6gtqaSyH9x2fbvH8Y0EfoVs/qNqwwI5d18k=";
    video_thumbnail = "sha256-7IbKg6bBA5D8ODwMNwJqIohTCbAox56TMgoI07CbrPw=";
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
    install -Dm0644 snap/gui/bluebubbles.png $out/share/pixmaps/bluebubbles.png
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
