{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocksndiamonds";
  version = "4.4.0.5";

  src = fetchurl {
    url = "https://www.artsoft.org/RELEASES/linux/rocksndiamonds/rocksndiamonds-${finalAttrs.version}-linux.tar.gz";
    hash = "sha256-8e6ZYpFoUQ4+ykHDLlKWWyUANPq1lXv7IRHYWfBOU/U=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "rocksndiamonds";
      exec = finalAttrs.meta.mainProgram;
      icon = "rocksndiamonds";
      comment = finalAttrs.meta.description;
      desktopName = "Rocks'n'Diamonds";
      genericName = "Tile-based puzzle";
      categories = [
        "Game"
        "LogicGame"
      ];
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    SDL2 # sdl2-config
    copyDesktopItems
  ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    zlib
  ];

  preConfigure = ''
    dataDir=$out/share/rocksndiamonds
    makeFlagsArray+=("CC=$CC" "AR=$AR" "RANLIB=$RANLIB" "BASE_PATH=$dataDir")
  '';

  installPhase = ''
    runHook preInstall

    iconDir=$out/share/icons/hicolor/32x32/apps
    mkdir -p $out/bin $iconDir $dataDir
    cp rocksndiamonds $out/bin/
    ln -s $dataDir/graphics/gfx_classic/icons/icon.png $iconDir/rocksndiamonds.png
    cp -r conf docs graphics levels music sounds $dataDir

    runHook postInstall
  '';

  # flaky with parallel building
  # ranlib: game_bd.a: error reading bd_caveengine.o: file truncated
  enableParallelBuilding = false;

  meta = {
    description = "Scrolling tile-based arcade style puzzle game";
    mainProgram = "rocksndiamonds";
    homepage = "https://www.artsoft.org/rocksndiamonds/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
