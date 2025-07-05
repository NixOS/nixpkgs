{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "platomav-cpumicrocodes";
  version = "0-unstable-2025-05-12";

  src = fetchFromGitHub {
    owner = "platomav";
    repo = "CPUMicrocodes";
    rev = "2bcc2d8cb648c3397ea7381ca6887a9e3fdd6164";
    hash = "sha256-nnim3432n3+iwD2alY1cigQE7GKnI8BkyZDJTzood+E=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/microcodes
    cp -r $src/* $out/share/microcodes
    rm $out/share/microcodes/README.md

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Intel, AMD, VIA & Freescale CPU Microcode Repositories";
    homepage = "https://github.com/platomav/CPUMicrocodes";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ johnrtitor ];
  };
}
