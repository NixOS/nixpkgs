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
    url = "https://github.com/SimonLarsen/${pname}/releases/download/v${version}/${pname}-${version}.love";
    sha256 = "sha256-1bFjhN7jL/PMYMJH1ete6uyHTYsTGgoP60sf/sJTLlU=";
  };

  icon = fetchurl {
    url = "https://tangramgames.dk/img/thumb/sienna.png";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "sienna";
      exec = pname;
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

    cp -v $src $out/share/games/lovegames/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/games/lovegames/${pname}.love
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast-paced one button platformer";
    mainProgram = "sienna";
    homepage = "https://tangramgames.dk/games/sienna";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = licenses.free;
  };

}
