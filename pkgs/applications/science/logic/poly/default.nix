{stdenv, fetchurl, gmp, cmake, python}:

let version = "0.1.4";
in

stdenv.mkDerivation {
  name = "libpoly-${version}";

  src = fetchurl {
    url = "https://github.com/SRI-CSL/libpoly/archive/v${version}.tar.gz";
    sha256 = "16x1pk2a3pcb5a0dzyw28ccjwkhmbsck4hy80ss7kx0dd7qgpi7j";
  };

  buildInputs = [ cmake gmp python ];

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/libpoly;
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
