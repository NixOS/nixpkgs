{ lib, stdenv, fetchurl, bzip2, gfortran, libX11, libXmu, libXt, libjpeg, libpng
, libtiff, ncurses, pango, pcre2, perl, readline, tcl, texLive, tk, xz, zlib
, less, texinfo, graphviz, icu, pkg-config, bison, imake, which, jdk, blas, lapack
, curl, Cocoa, Foundation, libobjc, libcxx, tzdata
, withRecommendedPackages ? true
, enableStrictBarrier ? false
, enableMemoryProfiling ? false
# R as of writing does not support outputting both .so and .a files; it outputs:
#     --enable-R-static-lib conflicts with --enable-R-shlib and will be ignored
, static ? false
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "R";
  version = "4.2.1";

  src = fetchurl {
    url = "https://cran.r-project.org/src/base/R-${lib.versions.major version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-TVLbSG0nhI5UYT1O6XetlS7AjOF4B+G1JbEM1ENsZD8=";
  };

  dontUseImakeConfigure = true;

  buildInputs = [
    bzip2 gfortran libX11 libXmu libXt libXt libjpeg libpng libtiff ncurses
    pango pcre2 perl readline texLive xz zlib less texinfo graphviz icu
    pkg-config bison imake which blas lapack curl tcl tk jdk
  ] ++ lib.optionals stdenv.isDarwin [ Cocoa Foundation libobjc libcxx ];

  patches = [
    ./no-usr-local-search-paths.patch
    ./test-reg-packages.patch
  ];

  # Test of the examples for package 'tcltk' fails in Darwin sandbox. See:
  # https://github.com/NixOS/nixpkgs/issues/146131
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure \
      --replace "-install_name libRblas.dylib" "-install_name $out/lib/R/lib/libRblas.dylib" \
      --replace "-install_name libRlapack.dylib" "-install_name $out/lib/R/lib/libRlapack.dylib" \
      --replace "-install_name libR.dylib" "-install_name $out/lib/R/lib/libR.dylib"
    substituteInPlace tests/Examples/Makefile.in \
      --replace "test-Examples: test-Examples-Base" "test-Examples:" # do not test the examples
  '';

  dontDisableStatic = static;

  preConfigure = ''
    configureFlagsArray=(
      --disable-lto
      --with${lib.optionalString (!withRecommendedPackages) "out"}-recommended-packages
      --with-blas="-L${blas}/lib -lblas"
      --with-lapack="-L${lapack}/lib -llapack"
      --with-readline
      --with-tcltk --with-tcl-config="${tcl}/lib/tclConfig.sh" --with-tk-config="${tk}/lib/tkConfig.sh"
      --with-cairo
      --with-libpng
      --with-jpeglib
      --with-libtiff
      --with-ICU
      ${lib.optionalString enableStrictBarrier "--enable-strict-barrier"}
      ${lib.optionalString enableMemoryProfiling "--enable-memory-profiling"}
      ${if static then "--enable-R-static-lib" else "--enable-R-shlib"}
      AR=$(type -p ar)
      AWK=$(type -p gawk)
      CC=$(type -p cc)
      CXX=$(type -p c++)
      FC="${gfortran}/bin/gfortran" F77="${gfortran}/bin/gfortran"
      JAVA_HOME="${jdk}"
      RANLIB=$(type -p ranlib)
      R_SHELL="${stdenv.shell}"
  '' + lib.optionalString stdenv.isDarwin ''
      --disable-R-framework
      --without-x
      OBJC="clang"
      CPPFLAGS="-isystem ${lib.getDev libcxx}/include/c++/v1"
      LDFLAGS="-L${lib.getLib libcxx}/lib"
  '' + ''
    )
    echo >>etc/Renviron.in "TCLLIBPATH=${tk}/lib"
    echo >>etc/Renviron.in "TZDIR=${tzdata}/share/zoneinfo"
  '';

  installTargets = [ "install" "install-info" "install-pdf" ];

  # The store path to "which" is baked into src/library/base/R/unix/system.unix.R,
  # but Nix cannot detect it as a run-time dependency because the installed file
  # is compiled and compressed, which hides the store path.
  postFixup = "echo ${which} > $out/nix-support/undetected-runtime-dependencies";

  doCheck = true;
  preCheck = "export HOME=$TMPDIR; export TZ=CET; bin/Rscript -e 'sessionInfo()'";

  enableParallelBuilding = true;

  # disable stackprotector on aarch64-darwin for now
  # https://github.com/NixOS/nixpkgs/issues/158730
  # see https://github.com/NixOS/nixpkgs/issues/127608 for a similar issue
  hardeningDisable = lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [ "stackprotector" ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "http://www.r-project.org/";
    description = "Free software environment for statistical computing and graphics";
    license = licenses.gpl2Plus;

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

    platforms = platforms.all;

    maintainers = with maintainers; [ jbedo ] ++ teams.sage.members;
  };
}
