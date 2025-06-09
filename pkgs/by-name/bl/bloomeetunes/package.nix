{
  autoPatchelfHook,
  lib,
  fetchFromGitHub,
  flutter324,
  mpv,
  makeDesktopItem,
  copyDesktopItems,
}:

flutter324.buildFlutterApplication rec {
  pname = "bloomeetunes";
  version = "2.11.6";

  src = fetchFromGitHub {
    owner = "HemantKArya";
    repo = "BloomeeTunes";
    tag = "v${version}+171";
    hash = "sha256-gSAe5S5rdcNLP4v7NTchQj3UJ/h6msLax9H77w+JJnk=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    youtube_explode_dart = "sha256-ctUSoXLUJCu23hvEzYy5EoTCv7gG79rEiMFX7i1RGX0=";
  };

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

  postInstall = ''
    install -Dm644 assets/icons/bloomee_new_logo_c.png $out/share/pixmaps/bloomeetunes.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/bloomeetunes/lib:${
      lib.makeLibraryPath [
        mpv
      ]
    }
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
