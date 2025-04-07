{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "0-unstable-2025-03-23";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "e956708244820d2b98620ef0ed10e63cb7d42b3a";
    hash = "sha256-fzQ8f6mB7cVRbwVOCxPD/4nFmI3s5mXzJagn8us6ngA=";
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
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
}
