{
  lib,
  stdenv,
  flutter,
  fetchFromGitHub,

  keybinder3,
  libayatana-appindicator,

  _experimental-update-script-combinators,
  runCommand,
  yq,
  gitUpdater,
}:
let
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "AminBhst";
    repo = "brisk";
    tag = "v${version}";
    hash = "sha256-V5ttjdmIK+vZ1iyR8j7e3mB5QOoclxhqJ1jELPKIHxY=";
  };
in
flutter.buildFlutterApplication {
  pname = "brisk";
  inherit version src;

  # yq . pubspec.lock
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  buildInputs = lib.optional stdenv.hostPlatform.isLinux [
    keybinder3
    libayatana-appindicator
  ];

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
    homepage = "https://github.com/AminBhst/brisk";
    license = with lib.licenses; [ gpl3Only ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "brisk";
  };
}
