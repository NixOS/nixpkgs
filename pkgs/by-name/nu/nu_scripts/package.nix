{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-07-08";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "b09b60cc434bb9be05ce2bbb6dc299760d13b18b";
    hash = "sha256-Vh2yuIMvYiYdCYWqFRx7G24hWrQ5iJr1byOV/pIkFyI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts

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
