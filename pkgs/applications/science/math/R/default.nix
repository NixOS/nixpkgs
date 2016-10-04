{ stdenv, fetchurl, bzip2, gfortran, libX11, libXmu, libXt, libjpeg, libpng
, libtiff, ncurses, pango, pcre, perl, readline, tcl, texLive, tk, xz, zlib
, less, texinfo, graphviz, icu, pkgconfig, bison, imake, which, jdk, openblas
, curl, Cocoa, Foundation, cf-private, libobjc, tzdata
, withRecommendedPackages ? true
, enableStrictBarrier ? false
}:

stdenv.mkDerivation rec {
  name = "R-3.2.3";

  src = fetchurl {
    url = "http://cran.r-project.org/src/base/R-3/${name}.tar.gz";
    sha256 = "b93b7d878138279234160f007cb9b7f81b8a72c012a15566e9ec5395cfd9b6c1";
  };

  buildInputs = [ bzip2 gfortran libX11 libXmu libXt
    libXt libjpeg libpng libtiff ncurses pango pcre perl readline
    texLive xz zlib less texinfo graphviz icu pkgconfig bison imake
    which jdk openblas curl ]
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ tcl tk ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa Foundation cf-private libobjc ];

  patches = [ ./no-usr-local-search-paths.patch ];

  preConfigure = ''
    configureFlagsArray=(
      --disable-lto
      --with${stdenv.lib.optionalString (!withRecommendedPackages) "out"}-recommended-packages
      --with-blas="-L${openblas}/lib -lopenblas"
      --with-lapack="-L${openblas}/lib -lopenblas"
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
      ${stdenv.lib.optionalString enableStrictBarrier "--enable-strict-barrier"}
      --enable-R-shlib
      AR=$(type -p ar)
      AWK=$(type -p gawk)
      CC=$(type -p gcc)
      CXX=$(type -p g++)
      FC="${gfortran}/bin/gfortran" F77="${gfortran}/bin/gfortran"
      JAVA_HOME="${jdk}"
      RANLIB=$(type -p ranlib)
      R_SHELL="${stdenv.shell}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
      --without-tcltk
      --without-aqua
      --disable-R-framework
      CC="clang"
      CXX="clang++"
      OBJC="clang"
  '' + ''
    )
    echo "TCLLIBPATH=${tk}/lib" >>etc/Renviron.in
  '';

  postConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|/usr/share/zoneinfo|${tzdata}/share/zoneinfo|g' src/library/base/R/datetime.R
    sed -i 's|getenv("R_SHARE_DIR")|"${tzdata}/share"|g' src/extra/tzone/localtime.c
  '';

  installTargets = [ "install" "install-info" "install-pdf" ];

  doCheck = true;

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

    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = stdenv.lib.platforms.linux;

    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
