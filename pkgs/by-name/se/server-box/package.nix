{
  lib,
  flutter332,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  gitUpdater,
}:

let
  version = "1.0.1201";

  src = fetchFromGitHub {
    owner = "lollipopkit";
    repo = "flutter_server_box";
    tag = "v${version}";
    hash = "sha256-ScPpEL2YxWw1aKEyzhoa0b931WF4hrdren4aSAlMpoU=";
  };
in
flutter332.buildFlutterApplication {
  pname = "server-box";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./gitHashes.json;

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
          inherit src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "server-box.pubspecSource" ./pubspec.lock.json)
      {
        command = [ ./update-gitHashes.py ];
        supportedFeatures = [ "silent" ];
      }
    ];
  };

  meta = {
    description = "Server status & toolbox";
    homepage = "https://github.com/lollipopkit/flutter_server_box";
    mainProgram = "ServerBox";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
