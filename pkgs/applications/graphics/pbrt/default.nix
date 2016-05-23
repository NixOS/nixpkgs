{stdenv, fetchgit, flex, bison, cmake, git, zlib}:

stdenv.mkDerivation rec {

  version = "2016-05-19";
  name = "pbrt-v3-${version}";
  src = fetchgit {
    url = "https://github.com/mmp/pbrt-v3.git";
    rev = "638249e5cf4596e129695c8df8525d43f11573ff";
    sha256 = "10ykqrg4zcfb4sfsg3z793c6vld6b6g8bzfyk7ya3yvvc9sdlr5g";
  };

  fetchSubmodules = true;

  buildInputs = [ git flex bison cmake zlib ];

  meta = {
    homepage = "http://pbrt.org";
    description = "The renderer described in the third edition of the book 'Physically Based Rendering: From Theory To Implementation'";
    platforms = stdenv.lib.platforms.linux ;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.juliendehos ];
    priority = 10;
  };
}
