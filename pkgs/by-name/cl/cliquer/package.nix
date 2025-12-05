{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.23";
  pname = "cliquer";

  # autotoolized version of the original cliquer
  src = fetchFromGitHub {
    owner = "dimpase";
    repo = "autocliquer";
    rev = "v${version}";
    hash = "sha256-SGpur3sF1dYQU97wprERUqlr6LIX+NyXZVl0eSEd3uM=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    description = "Routines for clique searching";
    longDescription = ''
      Cliquer is a set of C routines for finding cliques in an arbitrary weighted graph.
      It uses an exact branch-and-bound algorithm developed by Patric Östergård.
      It is designed with the aim of being efficient while still being flexible and
      easy to use.
    '';
    homepage = "https://users.aalto.fi/~pat/cliquer.html";
    downloadPage = src.meta.homepage; # autocliquer
    license = licenses.gpl2Plus;
    teams = [ teams.sage ];
    mainProgram = "cl";
    platforms = platforms.unix;
  };
}
