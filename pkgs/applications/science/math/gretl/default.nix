{ lib, stdenv, fetchurl, curl, fftw, gmp, gnuplot, gtk3, gtksourceview3, json-glib
, lapack, libxml2, mpfr, openblas, pkg-config, readline }:

stdenv.mkDerivation rec {
  pname = "gretl";
  version = "2023a";

  src = fetchurl {
    url = "mirror://sourceforge/gretl/${pname}-${version}.tar.xz";
    sha256 = "sha256-T1UwQhw/Tr/juYqVJBkst2LRBCIXPLvVd0N+QCJcVtM=";
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
  ];

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;
  # Missing install depends:
  #  cp: cannot stat '...-gretl-2022c/share/gretl/data/plotbars': Not a directory
  #  make[1]: *** [Makefile:73: install_datafiles] Error 1
  enableParallelInstalling = false;

  meta = with lib; {
    description = "A software package for econometric analysis";
    longDescription = ''
      gretl is a cross-platform software package for econometric analysis,
      written in the C programming language.
    '';
    homepage = "https://gretl.sourceforge.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dmrauh ];
    platforms = with platforms; all;
  };
}
