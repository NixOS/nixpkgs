{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  gettext,
  autoreconfHook,
  gmp,
  mpfr,
}:
stdenv.mkDerivation {
  pname = "fplll";
  version = "20160331";
  src = fetchFromGitHub {
    owner = "fplll";
    repo = "fplll";
    rev = "11dea26c2f9396ffb7a7191aa371343f1f74c5c3";
    hash = "sha256-K6aSTyaehSzHFUobjsuDTaGye75VVIK04WDkBRNknbI=";
  };
  nativeBuildInputs = [
    autoconf
    automake
    libtool
    gettext
    autoreconfHook
  ];
  buildInputs = [
    gmp
    mpfr
  ];
  meta = {
    description = "Lattice algorithms using floating-point arithmetic";
    homepage = "https://github.com/fplll/fplll";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
