{
  lib,
  flutter332,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  yq,
  server-box,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter332.buildFlutterApplication rec {
  pname = "server-box";
  version = "1.0.1189";

  src = fetchFromGitHub {
    owner = "lollipopkit";
    repo = "flutter_server_box";
    tag = "v${version}";
    hash = "sha256-gz+4uJe0JHi8oYNz/oLylkYUmHQA8wnxp/4TadYNMfo=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    circle_chart = "sha256-BcnL/hRf+Yv2U8Nkl7pc8BtncBW+M2by86jO5IbFIRk=";
    computer = "sha256-qaD6jn78zDyZBktwJ4WTQa8oCvCWQJOBDaozBVsXNb8=";
    dartssh2 = "sha256-XlbruyraMmZGNRppQdBLS89Qyd7mm5Noiap2BhZjEPw=";
    fl_build = "sha256-hCojuXFuN33/prCyuPcMoehWiGfaR2yOJA2V6dOuz4E=";
    fl_lib = "sha256-cauq5kbcCE52Jp3K/xBdHEmdfuF8aQsujNTjbE93Pww=";
    plain_notification_token = "sha256-Cy1/S8bAtKCBnjfDEeW4Q2nP4jtwyCstAC1GH1efu8I=";
    watch_connectivity = "sha256-9TyuElr0PNoiUvbSTOakdw1/QwWp6J2GAwzVHsgYWtM=";
    xterm = "sha256-yMETVh1qEdQAIYaQWbL5958N5dGpczJ/Y8Zvl1WjRnw=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "server-box";
      exec = "server-box";
      icon = "server-box";
      genericName = "ServerBox";
      desktopName = "ServerBox";
      categories = [ "Utility" ];
      keywords = [
        "server"
        "ssh"
        "sftp"
        "system"
      ];
    })
  ];

  postInstall = ''
    install -Dm0644 assets/app_icon.png $out/share/pixmaps/server-box.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (server-box) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "server-box.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Server status & toolbox";
    homepage = "https://github.com/lollipopkit/flutter_server_box";
    mainProgram = "ServerBox";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
