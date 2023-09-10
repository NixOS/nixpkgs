{ lib, stdenv, fetchurl, gfortran, arpack, spooles, blas, lapack }:

assert (blas.isILP64 == lapack.isILP64 &&
        blas.isILP64 == arpack.isILP64 &&
        !blas.isILP64);

stdenv.mkDerivation rec {
  pname = "calculix";
  version = "2.19";

  src = fetchurl {
    url = "http://www.dhondt.de/ccx_${version}.src.tar.bz2";
    sha256 = "01vdy9sns58hkm39z6d0r5y7gzqf5z493d18jin9krqib1l6jnn7";
  };

  nativeBuildInputs = [ gfortran ];

  buildInputs = [ arpack spooles blas lapack ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${spooles}/include/spooles"
    "-std=legacy"
  ];

  patches = [
    ./calculix.patch
  ];

  postPatch = ''
    cd ccx*/src
  '';

  installPhase = ''
    install -Dm0755 ccx_${version} $out/bin/ccx
  '';

  meta = with lib; {
    homepage = "http://www.calculix.de/";
    description = "Three-dimensional structural finite element program";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
