{stdenv, fetchFromGitHub, gmp, cmake, python}:

stdenv.mkDerivation rec {
  pname = "libpoly";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    rev = "v${version}";
    sha256 = "19ddzrir20571zqg720ajqpl59lhpc6c18bp763r6rw68d9zbjch";
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
