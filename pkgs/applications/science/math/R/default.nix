{ stdenv, fetchurl, blas, bzip2, gfortran, liblapack, libX11, libXmu, libXt
, libjpeg, libpng, libtiff, ncurses, pango, pcre, perl, readline, tcl
, texLive, tk, xz, zlib, less, texinfo, graphviz
}:

stdenv.mkDerivation rec {
  name = "R-3.0.1";

  src = fetchurl {
    url = "http://ftp5.gwdg.de/pub/misc/cran/src/base/R-3/${name}.tar.gz";
    sha256 = "0d3iv382bsyz6ad5fk382x7sy3qzgpqvd0fw26r0648lyf54i45g";
  };

  buildInputs = [ blas bzip2 gfortran liblapack libX11 libXmu libXt
    libXt libjpeg libpng libtiff ncurses pango pcre perl readline tcl
    texLive tk xz zlib less texinfo graphviz ];

  enableParallelBuilding = true;

  meta = {
    description = "a free software environment for statistical computing and graphics";
    homepage = "http://www.r-project.org/";
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
