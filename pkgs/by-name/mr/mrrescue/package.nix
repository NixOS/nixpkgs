{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  love,
  lua,
  makeWrapper,
  makeDesktopItem,
  strip-nondeterminism,
  zip,
}:

let
  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/mrrescue.png";
    sha256 = "1y5ahf0m01i1ch03axhvp2kqc6lc1yvh59zgvgxw4w7y3jryw20k";
  };

  desktopItem = makeDesktopItem {
    name = "mrrescue";
    exec = "mrrescue";
    icon = icon;
    comment = "Arcade-style fire fighting game";
    desktopName = "Mr. Rescue";
    genericName = "mrrescue";
    categories = [ "Game" ];
  };

in

stdenv.mkDerivation {
  pname = "mrrescue";
  version = "1.02d-unstable-2018-08-18";

  src = fetchFromGitHub {
    owner = "SimonLarsen";
    repo = "mrrescue";
    rev = "a5be73c60acb8d1be506f7b5e48e784492ba96ce";
    hash = "sha256-UDfMgE7LyyXioURclA56Kx+bTrwMNDPR3evCRJ3reRM=";
  };

  nativeBuildInputs = [
    lua
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

    makeWrapper ${love}/bin/love $out/bin/mrrescue --add-flags $out/share/games/lovegames/mrrescue.love

    chmod +x $out/bin/mrrescue
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description = "Arcade-style fire fighting game";
    mainProgram = "mrrescue";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.zlib;
    downloadPage = "http://tangramgames.dk/games/mrrescue";
  };

}
