{ lib, stdenv, fetchurl, curl, fftw, gmp, gnuplot, gtk3, gtksourceview3, json-glib
, lapack, libxml2, mpfr, openblas, pkg-config, readline }:

stdenv.mkDerivation rec {
  pname = "gretl";
  version = "2021a";

  src = fetchurl {
    url = "mirror://sourceforge/gretl/${pname}-${version}.tar.xz";
    sha256 = "sha256-BDaTv6PORiBnsEaU7uXJIKuxTqIgpY44vUmSViyME0A=";
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

  meta = with lib; {
    description = "A software package for econometric analysis";
    longDescription = ''
      gretl is a cross-platform software package for econometric analysis,
      written in the C programming language.
    '';
    homepage = "http://gretl.sourceforge.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dmrauh ];
    platforms = with platforms; all;
  };
}
