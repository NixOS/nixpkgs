{
  stdenv,
  lib,
  fetchurl,
  cmake,
  perl,
  gnuplot,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcerf";
  version = "3.2";

  src = fetchurl {
    url = "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v${finalAttrs.version}/libcerf-v${finalAttrs.version}.tar.gz";
    sha256 = "sha256-6o0RDXPsJKZDBCyjlARhzLsbZUHiExDstwq05NwUSu8=";
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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
