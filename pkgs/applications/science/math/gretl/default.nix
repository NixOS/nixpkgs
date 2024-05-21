{ lib
, stdenv
, fetchurl
, curl
, fftw
, gmp
, gnuplot
, gtk3
, gtksourceview3
, json-glib
, lapack
, libxml2
, mpfr
, openblas
, readline
, Accelerate
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gretl";
  version = "2024a";

  src = fetchurl {
    url = "mirror://sourceforge/gretl/gretl-${finalAttrs.version}.tar.xz";
    hash = "sha256-6ha0d/n75Xf0hZM0GRHLOnM274P1h2MerB/8SHWTh+o=";
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Accelerate
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  enableParallelBuilding = true;
  # Missing install depends:
  #  cp: cannot stat '...-gretl-2022c/share/gretl/data/plotbars': Not a directory
  #  make[1]: *** [Makefile:73: install_datafiles] Error 1
  enableParallelInstalling = false;

  meta = {
    description = "A software package for econometric analysis";
    homepage = "https://gretl.sourceforge.net";
    license = lib.licenses.gpl3;
    longDescription = ''
      gretl is a cross-platform software package for econometric analysis,
      written in the C programming language.
    '';
    maintainers = with lib.maintainers; [ dmrauh ];
    platforms = lib.platforms.all;
  };
})
