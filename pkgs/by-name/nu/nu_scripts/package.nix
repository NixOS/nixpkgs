{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-12-17";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "4af008a317185b4e247bdb13002dbc074e98b60c";
    hash = "sha256-KsS3Brtt9tXKpogXdGQJK6QfJq3tbGnyU/ydVaYggE4=";
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
