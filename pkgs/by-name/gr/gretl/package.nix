{
  lib,
  stdenv,
  fetchurl,
  curl,
  fftw,
  gmp,
  gnuplot,
  gtk3,
  gtksourceview3,
  json-glib,
  lapack,
  libxml2,
  mpfr,
  openblas,
  readline,
  pkg-config,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gretl";
  version = "2025b";

  src = fetchurl {
    url = "mirror://sourceforge/gretl/gretl-${finalAttrs.version}.tar.xz";
    hash = "sha256-DW0QXWbx0nMWTfjxO15ZGR/DsvFM7eee0DDsqrm5vHM=";
  };

  buildInputs = [
    curl
    fftw
    gmp
    gnuplot
    gtk3
    gtksourceview3
    json-glib
    lapack
    libxml2
    mpfr
    openblas
    readline
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  nativeBuildInputs = [
    pkg-config
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.cc.isClang "-lomp";

  enableParallelBuilding = true;
  # Missing install depends:
  #  cp: cannot stat '...-gretl-2022c/share/gretl/data/plotbars': Not a directory
  #  make[1]: *** [Makefile:73: install_datafiles] Error 1
  enableParallelInstalling = false;

  meta = {
    description = "Software package for econometric analysis";
    homepage = "https://gretl.sourceforge.net";
    license = lib.licenses.gpl3;
    longDescription = ''
      gretl is a cross-platform software package for econometric analysis,
      written in the C programming language.
    '';
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
