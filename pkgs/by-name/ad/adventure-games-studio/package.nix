{ lib
, fetchurl
, stdenv

, autoPatchelfHook
, makeWrapper
, dpkg

, libogg
, libtheora
, libvorbis
, SDL2
, SDL2_sound
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ags3";
  version = "3.6.1.23";

  src = fetchurl {
    url = "https://github.com/adventuregamestudio/ags/releases/download/v3.6.1.23/ags_${finalAttrs.version}_amd64.deb";
    hash = "sha256-dWL9V+mS5hxpF+QIWbiI+uBEwSOTc63gNN4JJ9F6ApM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libogg
    libtheora
    libvorbis
    SDL2
    SDL2_sound
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share}
    cp usr/bin/ags $out/bin/ags3
    cp -r usr/share $out/share
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.adventuregamestudio.co.uk/";
    description = "Adventure Game Studio engine (version 3) meant for running adventure games.";
    license = licenses.artistic2;
    maintainers = with maintainers; [ ByteSudoer ];
    platforms = platforms.unix;
    mainProgram = "ags3";
  };
})
