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
  version = "2.1.0";
  pname = "lcalc";

  src = fetchFromGitLab {
    owner = "sagemath";
    repo = pname;
    tag = version;
    hash = "sha256-v+7Uh6tPOfb3E9dqxx//RqD22XM4S/8ejS2v+D5G5pE=";
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
    maintainers = teams.sage.members;
    platforms = platforms.all;
  };
}
