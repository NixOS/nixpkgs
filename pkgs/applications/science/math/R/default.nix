{ stdenv, fetchurl, blas, bzip2, gfortran, liblapack, libX11, libXmu, libXt
, libjpeg, libpng, libtiff, ncurses, pango, pcre, perl, readline, tcl
, texLive, tk, xz, zlib, less, texinfo, graphviz, icu, pkgconfig, bison
, imake, which, jdk, atlas
, withRecommendedPackages ? true
}:

stdenv.mkDerivation rec {
  name = "R-3.1.2";

  src = fetchurl {
    url = "http://cran.r-project.org/src/base/R-3/${name}.tar.gz";
    sha256 = "0ypsm11c7n49pgh2ricyhhpfhas3famscdazzdp2zq70rapm1ldw";
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
      --with${stdenv.lib.optionalString (!withRecommendedPackages) "out"}-recommended-packages
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
      --enable-R-shlib
      AR=$(type -p ar)
      AWK=$(type -p gawk)
      CC=$(type -p gcc)
      CXX=$(type -p g++)
      FC="${gfortran}/bin/gfortran" F77="${gfortran}/bin/gfortran"
      JAVA_HOME="${jdk}"
      LDFLAGS="-L${gfortran.gcc}/lib"
      RANLIB=$(type -p ranlib)
      R_SHELL="${stdenv.shell}"
    )
    echo "TCLLIBPATH=${tk}/lib" >>etc/Renviron.in
  '';

  installTargets = [ "install" "install-info" "install-pdf" ];

  # Test suite fails: https://bugs.r-project.org/bugzilla/show_bug.cgi?id=15975.
  doCheck = false;

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://www.r-project.org/";
    description = "Free software environment for statistical computing and graphics";
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

    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
