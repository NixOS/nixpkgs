{ lib, stdenv, fetchurl, libtool
, cfitsio, curl, ghostscript, gsl, libgit2, libjpeg, libtiff, lzlib, wcslib }:

stdenv.mkDerivation rec {
  pname = "gnuastro";
  version = "0.21";

  src = fetchurl {
    url = "mirror://gnu/gnuastro/gnuastro-${version}.tar.gz";
    sha256 = "sha256-L7qZPYQiORUXtV9+tRF4iUbXqIaqFYSYT9Rni90nU38=";
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
