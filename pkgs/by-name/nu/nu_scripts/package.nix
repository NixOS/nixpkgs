{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2026-07-15";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "e0b8d1e0c167efa32e9f4c69761b67dc625cb529";
    hash = "sha256-hIjJLoeep28PxivoGl2f5jihb0ljrp6ObrWZ9oyeWi4=";
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
