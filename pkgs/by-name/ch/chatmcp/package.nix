{
  lib,
  flutter332,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  yq,
  chatmcp,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter332.buildFlutterApplication rec {
  pname = "chatmcp";
  version = "0.0.76";

  src = fetchFromGitHub {
    owner = "daodao97";
    repo = "chatmcp";
    tag = "v${version}";
    hash = "sha256-MU2AFiIvc3Y27/nX/OqYs/VKkw50cqznMY2zUdys8ts=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "chatmcp";
      exec = "chatmcp %U";
      icon = "chatmcp";
      desktopName = "ChatMCP";
    })
  ];

  postInstall = ''
    install -Dm0644 assets/logo.png $out/share/pixmaps/chatmcp.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          nativeBuildInputs = [ yq ];
          inherit (chatmcp) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "chatmcp.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "AI chat client implementing the Model Context Protocol";
    homepage = "https://github.com/daodao97/chatmcp";
    mainProgram = "chatmcp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
