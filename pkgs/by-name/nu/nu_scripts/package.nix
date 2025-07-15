{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nu_scripts";
  version = "0-unstable-2025-07-03";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "f0cd46cafc9d0d73efde0f2a0b6f455dd2dfbfe3";
    hash = "sha256-JEytcntdN+krsjzJdwa+pbF76Z2XhStdKS9/GZ9JjtE=";
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
