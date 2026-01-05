{
  lib,
  flutter332,
  fetchFromGitHub,
  copyDesktopItems,
  libayatana-appindicator,
  makeDesktopItem,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  src = fetchFromGitHub {
    owner = "Xmarmalade";
    repo = "alisthelper";
    rev = "84a4f025ce184eb9cd910b90397eef8edaa95127";
    hash = "sha256-Ju7AnUq59sk15YCvXhunr5r2/e2i26lWF3+pVY3oWzo=";
  };
in
flutter332.buildFlutterApplication {
  pname = "alisthelper";
  version = "0.2.0-unstable-2025-08-05";
  inherit src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [ libayatana-appindicator ];

  preBuild = ''
    packageRun build_runner build
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "alisthelper";
      exec = "alisthelper";
      icon = "alisthelper";
      desktopName = "Alist Helper";
    })
  ];

  postInstall = ''
    install -D --mode=0644 assets/alisthelper.png -t $out/share/pixmaps
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
      (nix-update-script { extraArgs = [ "--version=branch" ]; })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "alisthelper.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "Designed to simplify the use of the desktop version of alist/openlist";
    homepage = "https://github.com/Xmarmalade/alisthelper";
    mainProgram = "alisthelper";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
