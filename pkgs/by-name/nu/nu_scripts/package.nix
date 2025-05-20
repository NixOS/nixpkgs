{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "4ecbb0e04e0a944145c86ec8bf3e4fc7ca3958a5";
    hash = "sha256-ssqSZnc8YnCB/62eN9KQzf+cm686/NFKcj4M2sd0XxM=";
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
