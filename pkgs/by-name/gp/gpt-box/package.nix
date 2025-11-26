{
  lib,
  flutter329,
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
  version = "1.0.395";

  src = fetchFromGitHub {
    owner = "lollipopkit";
    repo = "flutter_gpt_box";
    tag = "v${version}";
    hash = "sha256-YtrsN8CdbCvbzfex8bCUUfqfTfyhhZfmweydaRSn1J4=";
  };
in
flutter329.buildFlutterApplication {
  pname = "gpt-box";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

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
    install -D --mode=0644 assets/app_icon.png $out/share/pixmaps/gpt-box.png
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
        (_experimental-update-script-combinators.copyAttrOutputToFile "gpt-box.pubspecSource" ./pubspec.lock.json)
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
    description = "Third-party client for OpenAI API";
    homepage = "https://github.com/lollipopkit/flutter_gpt_box";
    mainProgram = "GPTBox";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
