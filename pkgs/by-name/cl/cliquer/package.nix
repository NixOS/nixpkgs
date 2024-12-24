{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "1.22";
  pname = "cliquer";

  # autotoolized version of the original cliquer
  src = fetchFromGitHub {
    owner = "dimpase";
    repo = "autocliquer";
    rev = "v${version}";
    sha256 = "00gcmrhi2fjn8b246w5a3b0pl7p6haxy5wjvd9kcqib1xanz59z4";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
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
    maintainers = teams.sage.members;
    mainProgram = "cl";
    platforms = platforms.unix;
  };
}
