{
  stdenv,
  lib,
  fetchurl,
  cmake,
  perl,
  gnuplot,
}:

stdenv.mkDerivation rec {
  pname = "libcerf";
  version = "3.0";

  src = fetchurl {
    url = "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v${version}/libcerf-v${version}.tar.gz";
    sha256 = "sha256-xhCPvaia839YgRnAxUK2wegkhFo2vqL6MfftLMGiRts=";
  };

  nativeBuildInputs = [
    cmake
    perl
  ];

  passthru.tests = {
    inherit gnuplot;
  };

  meta = {
    description = "Complex error (erf), Dawson, Faddeeva, and Voigt function library";
    homepage = "https://jugit.fz-juelich.de/mlz/libcerf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.all;
  };
}
