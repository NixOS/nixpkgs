{
  lib,
  flutter329,
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

flutter329.buildFlutterApplication {
  pname = "server-box";
  version = "1.0.1130-unstable-2025-04-25";

  src = fetchFromGitHub {
    owner = "lollipopkit";
    repo = "flutter_server_box";
    rev = "8f09085cf30f9b48209c7c3c1e9dceac5aa5eeeb";
    hash = "sha256-D2FzL34FV+7FnxyEVi/Rm2qO3c9eQmCjlH/4pMWlU5s=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    circle_chart = "sha256-BcnL/hRf+Yv2U8Nkl7pc8BtncBW+M2by86jO5IbFIRk=";
    computer = "sha256-qaD6jn78zDyZBktwJ4WTQa8oCvCWQJOBDaozBVsXNb8=";
    dartssh2 = "sha256-bS916CwUuOKhRyymtmvMxt7vGXmlyiLep4AZsxRJ6iU=";
    fl_build = "sha256-CSKe2yEIisftM0q79HbDTghShirWg02zi9v+hD5R57g=";
    fl_lib = "sha256-+eHUpn89BI7k/MbCp09gUWGMlqLBrxOy9PgL9uXnkDI=";
    plain_notification_token = "sha256-Cy1/S8bAtKCBnjfDEeW4Q2nP4jtwyCstAC1GH1efu8I=";
    watch_connectivity = "sha256-9TyuElr0PNoiUvbSTOakdw1/QwWp6J2GAwzVHsgYWtM=";
    xterm = "sha256-LTCMaGVqehL+wFSzWd63KeTBjjU4xCyuhfD9QmQaP0Q=";
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
