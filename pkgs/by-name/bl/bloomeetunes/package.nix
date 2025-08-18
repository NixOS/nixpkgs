{
  lib,
  flutter327,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  mpv-unwrapped,
}:

let
  version = "2.12.3";
in
flutter327.buildFlutterApplication {
  pname = "bloomeetunes";
  inherit version;

  src = fetchFromGitHub {
    owner = "HemantKArya";
    repo = "BloomeeTunes";
    tag = "v${version}+177";
    hash = "sha256-PZXBdS9lmQGP2hTqCF+vsMwIPp/vHncqAmJWngWhRB4=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./gitHashes.json;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "bloomeetunes";
      exec = "bloomee";
      icon = "bloomeetunes";
      genericName = "Music Player";
      desktopName = "Bloomee Tunes";
    })
  ];

  preBuild = ''
    echo "CLIENT_ID = XXXXX\nCLIENT_SECRET = XXXX EOF" > assets/.env
  '';

  postInstall = ''
    install -Dm644 assets/icons/bloomee_new_logo_c.png $out/share/pixmaps/bloomeetunes.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/bloomeetunes/lib:${lib.makeLibraryPath [ mpv-unwrapped ]}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross-platform music app designed to bring you ad-free tunes from various sources";
    homepage = "https://github.com/HemantKArya/BloomeeTunes";
    mainProgram = "bloomee";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
