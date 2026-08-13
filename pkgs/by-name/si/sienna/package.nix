{
  lib,
  stdenv,
  fetchurl,
  love,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "sienna";
  version = "1.0d";

  src = fetchurl {
    url = "https://github.com/SimonLarsen/sienna/releases/download/v${version}/sienna-${version}.love";
    hash = "sha256-1bFjhN7jL/PMYMJH1ete6uyHTYsTGgoP60sf/sJTLlU=";
  };

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/sienna.png";
    hash = "sha256-1grwCi1sKelqEH58pO0rTSnqG7JOfVByNKu2NCbMAos=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "sienna";
      exec = "sienna";
      icon = icon;
      comment = "Fast-paced one button platformer";
      desktopName = "Sienna";
      genericName = "sienna";
      categories = [ "Game" ];
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v $src $out/share/games/lovegames/sienna.love

    makeWrapper ${lib.getExe love} $out/bin/sienna --add-flags $out/share/games/lovegames/sienna.love
    runHook postInstall
  '';

  meta = {
    description = "Fast-paced one button platformer";
    mainProgram = "sienna";
    homepage = "https://tangramgames.dk/games/sienna";
    platforms = love.meta.platforms;
    license = lib.licenses.zlib;
    maintainers = [ ];
  };

}
