{
  lib,
  stdenv,
  autoreconfHook,
  fetchurl,
  gmp,
  blas,
}:
stdenv.mkDerivation rec {
  pname = "iml";
  version = "1.0.5";
  src = fetchurl {
    url = "http://www.cs.uwaterloo.ca/~astorjoh/iml-${version}.tar.bz2";
    sha256 = "0akwhhz9b40bz6lrfxpamp7r7wkk48p455qbn04mfnl9a1l6db8x";
  };
  buildInputs = [
    gmp
    blas
  ];
  nativeBuildInputs = [
    autoreconfHook
  ];
  configureFlags = [
    "--with-gmp-include=${gmp.dev}/include"
    "--with-gmp-lib=${gmp}/lib"
    "--with-cblas=-lblas"
  ];
  meta = with lib; {
    description = "Algorithms for computing exact solutions to dense systems of linear equations over the integers";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    homepage = "https://cs.uwaterloo.ca/~astorjoh/iml.html";
  };
}
