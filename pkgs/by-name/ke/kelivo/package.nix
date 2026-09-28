{
  lib,
  fetchFromGitHub,
  flutter344,
  orc,
  gst_all_1,
  libunwind,
  keybinder3,
  libayatana-appindicator,
  makeDesktopItem,
  copyDesktopItems,
}:

flutter344.buildFlutterApplication (finalAttrs: {
  pname = "kelivo";
  version = "1.2.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Chevey339";
    repo = "kelivo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wTlHFJizR4aNm/TJbewKZPKwe01PYOGkXkM/Qsax71o=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # Under `__structuredAttrs = true`, passAsFile leaves pubspecLockFilePath empty.
  env.pubspecLockFilePath = "./pubspec.lock.json";

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    orc
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libunwind
    keybinder3
    libayatana-appindicator
  ];

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/kelivo/lib
  '';

  postInstall = ''
    install -Dm644 assets/app_icon.png $out/share/icons/hicolor/1024x1024/apps/kelivo.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "kelivo";
      desktopName = "Kelivo";
      exec = "kelivo %U";
      terminal = false;
      type = "Application";
      icon = "kelivo";
      startupWMClass = "Kelivo";
      comment = "Flutter LLM Chat Client";
      categories = [
        "Network"
        "Utility"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Flutter LLM Chat Client";
    homepage = "https://kelivo.psycheas.top/";
    downloadPage = "https://github.com/Chevey339/kelivo/releases";
    changelog = "https://github.com/Chevey339/kelivo/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux;
    mainProgram = "kelivo";
  };
})
