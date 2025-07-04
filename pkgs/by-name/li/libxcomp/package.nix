{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libjpeg,
  libpng,
  libX11,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libxcomp";
  version = "3.5.99.16";

  src = fetchurl {
    sha256 = "1m3z9w3h6qpgk265xf030w7lcs181jgw2cdyzshb7l97mn1f7hh2";
    url = "https://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-lite.tar.gz";
  };

  buildInputs = [
    libjpeg
    libpng
    libX11
    zlib
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preAutoreconf = ''
    cd nxcomp/
    sed -i 's|/src/.libs/libXcomp.a|/src/.libs/libXcomp.la|' test/Makefile.am
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "NX compression library";
    homepage = "http://wiki.x2go.org/doku.php/wiki:libs:nx-libs";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
