{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "durden";
  version = "unstable-2023-10-23";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "durden";
    rev = "347dba6da011bbaa70c6edaf82a2d915f4057db3";
    hash = "sha256-iNf7fOzz7mf1CXG5leCenkSTrdCc9/KL8VLw8gUIyKE=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/
    cp -a ./durden ${placeholder "out"}/share/arcan/appl/

    runHook postInstall
  '';

  meta = {
    homepage = "https://durden.arcan-fe.com/";
    description = "Reference Desktop Environment for Arcan";
    longDescription = ''
      Durden is a desktop environment for the Arcan Display Server. It serves
      both as a reference showcase on how to take advantage of some of the
      features in Arcan, and as a very competent entry to the advanced-user side
      of the desktop environment spectrum.
    '';
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
