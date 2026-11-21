{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  love,
  lua5_2_compat,
  makeWrapper,
  makeDesktopItem,
  strip-nondeterminism,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mrrescue";
  version = "1.02d-unstable-2018-08-18";

  desktopItem = makeDesktopItem {
    name = "mrrescue";
    exec = "mrrescue";
    icon = fetchurl {
      url = "http://tangramgames.dk/img/thumb/mrrescue.png";
      hash = "sha256-Ewjusxz+cML72++nArcPjBqGp7gbdjUAZCEGUIGDqvg=";
    };
    comment = "Arcade-style fire fighting game";
    desktopName = "Mr. Rescue";
    genericName = "mrrescue";
    categories = [ "Game" ];
  };

  src = fetchFromGitHub {
    owner = "SimonLarsen";
    repo = "mrrescue";
    rev = "a5be73c60acb8d1be506f7b5e48e784492ba96ce";
    hash = "sha256-UDfMgE7LyyXioURclA56Kx+bTrwMNDPR3evCRJ3reRM=";
  };

  nativeBuildInputs = [
    lua5_2_compat
    love
    makeWrapper
    strip-nondeterminism
    zip
  ];

  buildPhase = ''
    runHook preBuild
    zip -9 -r mrrescue.love ./*
    strip-nondeterminism --type zip mrrescue.love
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/games/lovegames

    cp -v mrrescue.love $out/share/games/lovegames/mrrescue.love

    makeWrapper ${lib.getExe love} $out/bin/mrrescue --add-flags $out/share/games/lovegames/mrrescue.love

    chmod +x $out/bin/mrrescue
    mkdir -p $out/share/applications
    ln -s ${finalAttrs.desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = {
    description = "Arcade-style fire fighting game";
    homepage = "https://github.com/SimonLarsen/mrrescue";
    mainProgram = "mrrescue";
    maintainers = [ ];
    platforms = love.meta.platforms;
    license = lib.licenses.zlib;
    downloadPage = "http://tangramgames.dk/games/mrrescue";
  };

})
