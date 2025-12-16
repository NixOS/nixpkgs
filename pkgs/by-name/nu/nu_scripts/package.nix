{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-12-09";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "3d6b378c151fee9be3f0dc97fb1fab990c55181a";
    hash = "sha256-uMFoC4gtKTq2JIPOgmkdEyqVNg8eJxnU9UM1GsFVTh0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
    rm -r $out/share/nu_scripts/themes/screenshots

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Place to share Nushell scripts with each other";
    homepage = "https://github.com/nushell/nu_scripts";
    license = lib.licenses.mit;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
}
