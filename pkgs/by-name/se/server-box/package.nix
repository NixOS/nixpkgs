{
  lib,
  flutter335,
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
  version = "1.0.1262";

  src = fetchFromGitHub {
    owner = "lollipopkit";
    repo = "flutter_server_box";
    tag = "v${version}";
    hash = "sha256-2UJgqNLwVttmc/D4DEhC7oe2yhFNdkvFnOCRVV3WVFk=";
  };
in
flutter335.buildFlutterApplication {
  pname = "server-box";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./gitHashes.json;

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  # https://github.com/juliansteenbakker/flutter_secure_storage/issues/965
  CXXFLAGS = [ "-Wno-deprecated-literal-operator" ];

  desktopItems = [
    (makeDesktopItem {
      name = "server-box";
      exec = "ServerBox";
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
    install -D --mode=0644 assets/app_icon.png $out/share/icons/hicolor/512x512/apps/server-box.png
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
    changelog = "https://github.com/lollipopkit/flutter_server_box/releases/tag/${src.tag}";
    mainProgram = "ServerBox";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
}
