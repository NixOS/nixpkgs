{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  pkg-config,
  SDL,
  SDL_ttf,
  SDL_gfx,
  SDL_mixer,
  libpng,
  glew,
  fontconfig,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyperrogue";
  version = "13.1e";

  src = fetchFromGitHub {
    owner = "zenorogue";
    repo = "hyperrogue";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-teoSI6JrqDAkyNhVaIVZcfM93LxjQah0+eJFKfI5iP4=";
  };

  env = {
    FONTCONFIG = 1;
    HYPERROGUE_USE_GLEW = 1;
    HYPERROGUE_USE_PNG = 1;
    HYPERROGUE_USE_ROGUEVIZ = 1;
  };

  CXXFLAGS = [
    "-I${lib.getDev SDL}/include/SDL"
    "-DHYPERPATH='\"${placeholder "out"}/share/hyperrogue/\"'"
    "-DRESOURCEDESTDIR=HYPERPATH"
  ];

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    SDL
    SDL_ttf
    SDL_gfx
    SDL_mixer
    libpng
    glew
    fontconfig
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "hyperrogue";
      desktopName = "HyperRogue";
      genericName = "HyperRogue";
      comment = finalAttrs.meta.description;
      icon = "hyperrogue";
      exec = "hyperrogue";
      categories = [
        "Game"
        "AdventureGame"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/share/hyperrogue/{sounds,music}

    install -m 555 -D hyperrogue $out/bin/hyperrogue
    install -m 444 -D hyperrogue-music.txt *.dat $out/share/hyperrogue
    install -m 444 -D music/* $out/share/hyperrogue/music
    install -m 444 -D sounds/* $out/share/hyperrogue/sounds

    install -m 444 -D hyperroid/app/src/main/res/drawable-ldpi/icon.png \
      $out/share/icons/hicolor/36x36/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-mdpi/icon.png \
      $out/share/icons/hicolor/48x48/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-hdpi/icon.png \
      $out/share/icons/hicolor/72x72/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-xhdpi/icon.png \
      $out/share/icons/hicolor/96x96/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-xxhdpi/icon.png \
      $out/share/icons/hicolor/144x144/apps/hyperrogue.png
    install -m 444 -D hyperroid/app/src/main/res/drawable-xxxhdpi/icon.png \
      $out/share/icons/hicolor/192x192/apps/hyperrogue.png

    runHook postInstall
  '';

  enableParallelBuilding = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Roguelike game set in hyperbolic geometry";
    homepage = "https://www.roguetemple.com/z/hyper/";
    changelog = "https://github.com/zenorogue/hyperrogue/releases/tag/v${finalAttrs.version}";
    mainProgram = "hyperrogue";
    maintainers = with lib.maintainers; [ rardiol ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
