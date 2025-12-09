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
  nix-update-script,
  dart,
}:

let
  version = "1.0.1270";

  src = fetchFromGitHub {
    owner = "lollipopkit";
    repo = "flutter_server_box";
    tag = "v${version}";
    hash = "sha256-3erwb2e9iINe4MVuOQKzBuBdUJyBgW2zIImZwVyll6Q=";
  };
in
flutter335.buildFlutterApplication {
  pname = "server-box";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

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
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "server-box.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
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
