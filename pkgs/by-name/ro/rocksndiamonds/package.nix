{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "rocksndiamonds";
  version = "4.4.0.5";

  src = fetchurl {
    url = "https://www.artsoft.org/RELEASES/linux/${pname}/${pname}-${version}-linux.tar.gz";
    hash = "sha256-8e6ZYpFoUQ4+ykHDLlKWWyUANPq1lXv7IRHYWfBOU/U=";
  };

  desktopItem = makeDesktopItem {
    name = "rocksndiamonds";
    exec = "rocksndiamonds";
    icon = "rocksndiamonds";
    comment = meta.description;
    desktopName = "Rocks'n'Diamonds";
    genericName = "Tile-based puzzle";
    categories = [
      "Game"
      "LogicGame"
    ];
  };

  strictDeps = true;

  nativeBuildInputs = [
    SDL2 # sdl2-config
  ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    zlib
  ];

  preConfigure = ''
    makeFlagsArray+=("CC=$CC" "AR=$AR" "RANLIB=$RANLIB")
  '';

  preBuild = ''
    dataDir="$out/share/rocksndiamonds"
    appendToVar makeFlags "BASE_PATH=$dataDir"
  '';

  installPhase = ''
    runHook preInstall

    appDir=$out/share/applications
    iconDir=$out/share/icons/hicolor/32x32/apps
    mkdir -p $out/bin $appDir $iconDir $dataDir
    cp rocksndiamonds $out/bin/
    ln -s ${desktopItem}/share/applications/* $appDir/
    ln -s $dataDir/graphics/gfx_classic/icons/icon.png $iconDir/rocksndiamonds.png
    cp -r conf docs graphics levels music sounds $dataDir

    runHook postInstall
  '';

  # flaky with parallel building
  # ranlib: game_bd.a: error reading bd_caveengine.o: file truncated
  enableParallelBuilding = false;

  meta = with lib; {
    description = "Scrolling tile-based arcade style puzzle game";
    mainProgram = "rocksndiamonds";
    homepage = "https://www.artsoft.org/rocksndiamonds/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
