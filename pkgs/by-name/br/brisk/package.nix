{
  lib,
  stdenv,
  flutter332,
  fetchFromGitHub,

  keybinder3,
  libayatana-appindicator,
  ffmpeg,

  _experimental-update-script-combinators,
  runCommand,
  yq,
  gitUpdater,
}:
let
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "BrisklyDev";
    repo = "brisk";
    tag = "v${version}";
    hash = "sha256-yU+BuqFcdOdwXTNkUEPXNFhc5NakplUWOI72wFYOAHI=";
  };
in
flutter332.buildFlutterApplication {
  pname = "brisk";
  inherit version src;

  # yq . pubspec.lock
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    window_manager = "sha256-WKcNwEOthXj1S2lKlpdhy+r8JZslVqhwY2ywXeTSBEs=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    keybinder3
    libayatana-appindicator
  ];

  # As requested by upstream
  # https://github.com/NixOS/nixpkgs/pull/367627#issuecomment-2923244545
  flutterBuildFlags = [ "--dart-define=BUILD_METHOD=Nix" ];

  # Provide a fallback for FFmpeg integration
  extraWrapProgramArgs = ''
    --suffix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  passthru = {
    pubspecSource = runCommand "pubspec.lock.json" { buildInputs = [ yq ]; } ''
      yq . ${src}/pubspec.lock > $out
    '';

    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "brisk.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Ultra-fast, modern download manager for desktop";
    homepage = "https://github.com/BrisklyDev/brisk";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "brisk";
  };
}
