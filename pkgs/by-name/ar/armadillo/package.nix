{
  lib,
  stdenv,
  fetchurl,
  cmake,
  blas,
  lapack,
  superlu,
  hdf5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "armadillo";
  version = "15.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${finalAttrs.version}.tar.xz";
    hash = "sha256-l8uO9whUH2Muhh0AWkYt0DZyQPgf+W+OY+u911yM5V8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blas
    lapack
    superlu
    hdf5
  ];

  cmakeFlags = [
    "-DLAPACK_LIBRARY=${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DDETECT_HDF5=ON"
  ];

  patches = [ ./use-unix-config-on-OS-X.patch ];

  meta = {
    description = "C++ linear algebra library";
    homepage = "https://arma.sourceforge.net";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      juliendehos
    ];
  };
})
