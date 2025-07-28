{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-07-24";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "bd128cf5257bf3f6c3453cbb4fd431d01d3467db";
    hash = "sha256-8sJc7oF0m/hi/Uqm1X6ciIYAk5zW8hm0byX2RVZS6V8=";
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
