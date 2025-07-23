{
  lib,
  flutter329,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  yq,
  gpt-box,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter329.buildFlutterApplication rec {
  pname = "gpt-box";
  version = "1.0.385";

  src = fetchFromGitHub {
    owner = "lollipopkit";
    repo = "flutter_gpt_box";
    tag = "v${version}";
    hash = "sha256-gl8kANxZLNXSuZxcK9WqfXxVWsCpZCbV+qmSt2ZnI6E=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    computer = "sha256-qaD6jn78zDyZBktwJ4WTQa8oCvCWQJOBDaozBVsXNb8=";
    fl_build = "sha256-CSKe2yEIisftM0q79HbDTghShirWg02zi9v+hD5R57g=";
    fl_lib = "sha256-gAZqxPOBMXfy0mHEd7Jud0QJwyRbqC4nIRDIA81TZxM=";
    flutter_highlight = "sha256-jSATD4Ww5FHEscGNiTN/FE1+iQHzg/XMbsC9f5XcNGw=";
    openai_dart = "sha256-FP8J8ul8F68vrEdEZAmzNS921evtRfCIOlV2Aubifaw=";
    webdav_client = "sha256-aTkMcrXksHLEG4UpeE1MBmCKpX5l11+y/p4tICrOTGk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "gpt-box";
      exec = "gpt-box";
      icon = "gpt-box";
      genericName = "GPT Box";
      desktopName = "GPT Box";
      categories = [ "Utility" ];
      keywords = [
        "gpt"
        "chat"
        "openai"
        "ai"
      ];
    })
  ];

  postInstall = ''
    install -Dm0644 assets/app_icon.png $out/share/pixmaps/gpt-box.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (gpt-box) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "gpt-box.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Third-party client for OpenAI API";
    homepage = "https://github.com/lollipopkit/flutter_gpt_box";
    mainProgram = "GPTBox";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
