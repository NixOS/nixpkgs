{stdenv, fetchurl, gmp, cmake, python}:

let version = "0.1.5";
in

stdenv.mkDerivation {
  name = "libpoly-${version}";

  src = fetchurl {
    url = "https://github.com/SRI-CSL/libpoly/archive/v${version}.tar.gz";
    sha256 = "0yj3gd60lx8dcgw7hgld8wqvjkpixx3ww3v33sdf7p6lln7ksxyn";
  };

  buildInputs = [ cmake gmp python ];

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/libpoly;
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
