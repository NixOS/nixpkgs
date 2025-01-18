{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "durden";
  version = "0-unstable-2024-06-23";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "durden";
    rev = "dffb94b69355ffa9cda074c1d0a48af74b78c220";
    hash = "sha256-sBhlBk4vAYwedw4VerUfY80SXbVoEDid54si6qwDeXs=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/
    cp -a ./durden ${placeholder "out"}/share/arcan/appl/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://durden.arcan-fe.com/";
    description = "Reference Desktop Environment for Arcan";
    longDescription = ''
      Durden is a desktop environment for the Arcan Display Server. It serves
      both as a reference showcase on how to take advantage of some of the
      features in Arcan, and as a very competent entry to the advanced-user side
      of the desktop environment spectrum.
    '';
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
})
