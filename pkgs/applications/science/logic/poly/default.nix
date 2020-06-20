{stdenv, fetchFromGitHub, gmp, cmake, python}:

stdenv.mkDerivation rec {
  pname = "libpoly";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    # they've pushed to the release branch, use explicit tag
    rev = "refs/tags/v${version}";
    sha256 = "1n3gijksnl2ybznq4lkwm2428f82423sxq18gnb2g1kiwqlzdaa3";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gmp python ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/SRI-CSL/libpoly";
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
