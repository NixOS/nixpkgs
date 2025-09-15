{
  lib,
  copyDesktopItems,
  fetchFromGitHub,
  love,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  strip-nondeterminism,
  zip,
}:

stdenv.mkDerivation rec {
  pname = "mari0";
  version = "1.6.2-unstable-2023-08-08";

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = "mari0";
    rev = "57829fd23e783d1a2993b9d64a7f7e6b131e572f";
    sha256 = "sha256-rmsj6gMTleeWx911j5/sfpfQG54HDtsfsTyPDbEkLhE=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    strip-nondeterminism
    zip
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "mari0";
      exec = "mari0";
      comment = "Crossover between Super Mario Bros. and Portal";
      desktopName = "mari0";
      genericName = "mari0";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    zip -9 -r mari0.love ./*
    strip-nondeterminism --type zip mari0.love
    install -Dm444 -t $out/share/games/lovegames/ mari0.love
    makeWrapper ${love}/bin/love $out/bin/mari0 \
      --add-flags $out/share/games/lovegames/mari0.love
    runHook postInstall
  '';

  meta = with lib; {
    description = "Crossover between Super Mario Bros. and Portal";
    mainProgram = "mari0";
    platforms = platforms.linux;
    license = licenses.mit;
    downloadPage = "https://stabyourself.net/mari0/";
  };

}
