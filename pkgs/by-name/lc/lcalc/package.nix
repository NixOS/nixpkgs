{
  lib,
  stdenv,
  autoreconfHook,
  gengetopt,
  pkg-config,
  fetchFromGitLab,
  pari,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.2.1";
  pname = "lcalc";

  src = fetchFromGitLab {
    owner = "sagemath";
    repo = "lcalc";
    tag = finalAttrs.version;
    hash = "sha256-L9502+lwSPLk63C14Pxa8OZWhnY4OqKv9WudZO2vP7E=";
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

  meta = {
    homepage = "https://gitlab.com/sagemath/lcalc";
    description = "Program for calculating with L-functions";
    mainProgram = "lcalc";
    license = with lib.licenses; [ gpl2 ];
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.all;
  };
})
