{
  lib,
  fetchFromGitHub,
  flutter327,
  libayatana-appindicator,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  yq,
  alisthelper,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter327.buildFlutterApplication {
  pname = "alisthelper";
  version = "0.2.0-unstable-2025-01-04";

  src = fetchFromGitHub {
    owner = "Xmarmalade";
    repo = "alisthelper";
    rev = "181a1207df0c9eb8336097b9a9249342dd9df097";
    hash = "sha256-6FJd+8eJoRK3cEdkLCgr7q4L6kEeSsMMkiVRx6Pa5jk=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    libayatana-appindicator
  ];

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
    install -Dm644 assets/alisthelper.png -t $out/share/pixmaps
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          buildInputs = [ yq ];
          inherit (alisthelper) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "alisthelper.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Designed to simplify the use of the desktop version of alist";
    homepage = "https://github.com/Xmarmalade/alisthelper";
    mainProgram = "alisthelper";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
