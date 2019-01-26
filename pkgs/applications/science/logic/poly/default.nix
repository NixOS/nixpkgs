{stdenv, fetchFromGitHub, gmp, cmake, python}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libpoly";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "libpoly";
    rev = "v${version}";
    sha256 = "0i5ar4lhs88glk0rvkmag656ii434i6i1q5dspx6d0kyg78fii64";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gmp python ];

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/libpoly;
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
