{
  lib,
  stdenv,
  autoreconfHook,
  gengetopt,
  pkg-config,
  fetchFromGitLab,
  pari,
}:

stdenv.mkDerivation rec {
  version = "2.1.1";
  pname = "lcalc";

  src = fetchFromGitLab {
    owner = "sagemath";
    repo = "lcalc";
    tag = version;
    hash = "sha256-0CYrRGn5YQ07BaGu0Q5otnjwyh3sNq21EXp3M/KlRdw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gengetopt
    pkg-config
  ];

  buildInputs = [
    pari
  ];

  configureFlags = [
    "--with-pari"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/sagemath/lcalc";
    description = "Program for calculating with L-functions";
    mainProgram = "lcalc";
    license = with licenses; [ gpl2 ];
    teams = [ teams.sage ];
    platforms = platforms.all;
  };
}
