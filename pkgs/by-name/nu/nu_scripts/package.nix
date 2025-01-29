{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "0-unstable-2025-01-17";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "fd686c0b0c10e284b1da72d6c3c42ab28c7504a7";
    hash = "sha256-nO7Dyg1ZxjSInkWW+kHa32H0P1CQ6vc6ODLLTj2abcI=";
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
