{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-06-05";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "6fe7713322d95be89677389f812eceab6d4b89e2";
    hash = "sha256-Dq5KwKpnpX9YJIj7FM5fNaeMNdk/BHji2CesIE6Ndps=";
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
