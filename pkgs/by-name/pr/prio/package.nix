{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "prio";
  version = "0-unstable-2018-09-13";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "prio";
    rev = "c3f97491339d15f063d6937d5f89bcfaea774dd1";
    hash = "sha256-Idv/duEYmDk/rO+TI8n+FY3VFDtUEh8C292jh12BJuM=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/prio
    cp -a ./* ${placeholder "out"}/share/arcan/appl/prio

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/letoram/prio";
    description = "Plan9- Rio like Window Manager for Arcan";
    license = with lib.licenses; [ bsd3 ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
