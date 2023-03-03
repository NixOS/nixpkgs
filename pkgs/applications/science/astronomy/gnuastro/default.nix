{ lib, stdenv, fetchurl, libtool
, cfitsio, curl, ghostscript, gsl, libgit2, libjpeg, libtiff, lzlib, wcslib }:

stdenv.mkDerivation rec {
  pname = "gnuastro";
  version = "0.19";

  src = fetchurl {
    url = "mirror://gnu/gnuastro/gnuastro-${version}.tar.gz";
    sha256 = "sha256-4bPNW0sSb/J34vSOit8BA9Z/wK0Hz5o9OqfgVSlDDjU=";
  };

  nativeBuildInputs = [ libtool ];

  buildInputs = [
    cfitsio
    curl
    ghostscript
    gsl
    libgit2
    libjpeg
    libtiff
    lzlib
    wcslib
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "GNU astronomy utilities and library";
    homepage = "https://www.gnu.org/software/gnuastro/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
