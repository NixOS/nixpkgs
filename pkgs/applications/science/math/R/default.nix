{ stdenv, fetchurl, blas, bzip2, gfortran, liblapack, libX11, libXmu, libXt
, libjpeg, libpng, libtiff, ncurses, pango, pcre, perl, readline, tcl
, texLive, tk, xz, zlib, less, texinfo, graphviz, icu, pkgconfig, bison
, imake, which, jdk, atlas
}:

stdenv.mkDerivation rec {
  name = "R-3.0.1";

  src = fetchurl {
    url = "http://ftp5.gwdg.de/pub/misc/cran/src/base/R-3/${name}.tar.gz";
    sha256 = "0d3iv382bsyz6ad5fk382x7sy3qzgpqvd0fw26r0648lyf54i45g";
  };

  buildInputs = [ blas bzip2 gfortran liblapack libX11 libXmu libXt
    libXt libjpeg libpng libtiff ncurses pango pcre perl readline tcl
    texLive tk xz zlib less texinfo graphviz icu pkgconfig bison imake
    which jdk atlas
  ];

  patches = [ ./no-usr-local-search-paths.patch ];

  preConfigure = ''
    configureFlagsArray=(
      --disable-lto
      --with-blas="-L${atlas}/lib -lf77blas -latlas"
      --with-lapack="-L${liblapack}/lib -llapack"
      --with-readline
      --with-tcltk --with-tcl-config="${tcl}/lib/tclConfig.sh" --with-tk-config="${tk}/lib/tkConfig.sh"
      --with-cairo
      --with-libpng
      --with-jpeglib
      --with-libtiff
      --with-system-zlib
      --with-system-bzlib
      --with-system-pcre
      --with-system-xz
      --with-ICU
      R_SHELL="${stdenv.shell}"
      JAVA_HOME="${jdk}"
      LDFLAGS="-L${gfortran.gcc}/lib"
    )
    echo "TCLLIBPATH=${tk}/lib" >>etc/Renviron.in
  '';

  installTargets = [ "install" "install-info" "install-pdf" ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.r-project.org/";
    description = "a free software environment for statistical computing and graphics";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      GNU R is a language and environment for statistical computing and
      graphics that provides a wide variety of statistical (linear and
      nonlinear modelling, classical statistical tests, time-series
      analysis, classification, clustering, ...) and graphical
      techniques, and is highly extensible. One of R's strengths is the
      ease with which well-designed publication-quality plots can be
      produced, including mathematical symbols and formulae where
      needed. R is an integrated suite of software facilities for data
      manipulation, calculation and graphical display. It includes an
      effective data handling and storage facility, a suite of operators
      for calculations on arrays, in particular matrices, a large,
      coherent, integrated collection of intermediate tools for data
      analysis, graphical facilities for data analysis and display
      either on-screen or on hardcopy, and a well-developed, simple and
      effective programming language which includes conditionals, loops,
      user-defined recursive functions and input and output facilities.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
