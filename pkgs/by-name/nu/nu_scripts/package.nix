{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-08-29";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "2bccba62d66ed6e58073fe6cae743bf84f8e4ed0";
    hash = "sha256-Bd0QnhHza8r4D9njGVJ6Y6tXyfPamuvKRYX0aSPNofg=";
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
