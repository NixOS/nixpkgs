{
  lib,
  flutter329,
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

flutter329.buildFlutterApplication rec {
  pname = "chatmcp";
  version = "0.0.57";

  src = fetchFromGitHub {
    owner = "daodao97";
    repo = "chatmcp";
    tag = "v${version}";
    hash = "sha256-V4Tf3nIGMytVuSRlHDd8FvG4qyrpESM1cZKJS9PRCMg=";
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
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
