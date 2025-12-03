{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-11-26";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "248f65e7ba5661cc9f88b37e1a2f30f62f345657";
    hash = "sha256-w8jCv6QCdxuSyHjp4z7wYMCYUrvw+otppqfWPL9jGkQ=";
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
