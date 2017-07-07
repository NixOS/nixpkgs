{stdenv, fetchurl, gmp, cmake, python}:

let version = "0.1.3";
in

stdenv.mkDerivation {
  name = "libpoly-${version}";

  src = fetchurl {
    url = "https://github.com/SRI-CSL/libpoly/archive/v${version}.tar.gz";
    sha256 = "0nd90585imnznyp04vg6a5ixxkd3bavhv1437397aj2k3dfc0y2k";
  };

  buildInputs = [ cmake gmp python ];

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/libpoly;
    description = "C library for manipulating polynomials";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
