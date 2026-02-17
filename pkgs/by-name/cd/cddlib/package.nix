{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  autoreconfHook,
  texliveSmall,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cddlib";
  version = "0.94n";
  src = fetchFromGitHub {
    owner = "cddlib";
    repo = "cddlib";
    rev = finalAttrs.version;
    sha256 = "sha256-j4gXrxsWWiJH5gZc2ZzfYGsBCMJ7G7SQ1xEgurRWZrQ=";
  };
  buildInputs = [ gmp ];
  nativeBuildInputs = [
    autoreconfHook
    texliveSmall # for building the documentation
  ];
  # No actual checks yet (2018-05-05), but maybe one day.
  # Requested here: https://github.com/cddlib/cddlib/issues/25
  doCheck = true;
  meta = {
    description = "Implementation of the Double Description Method for generating all vertices of a convex polyhedron";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
    homepage = "https://www.inf.ethz.ch/personal/fukudak/cdd_home/index.html";
  };
})
