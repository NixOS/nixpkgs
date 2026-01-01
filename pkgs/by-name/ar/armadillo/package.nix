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

stdenv.mkDerivation rec {
  pname = "armadillo";
<<<<<<< HEAD
  version = "15.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    hash = "sha256-juAc1NpVvAe3vH08unAqxugTfThNfnGF8/SuHwx5cE8=";
=======
  version = "15.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/arma/armadillo-${version}.tar.xz";
    hash = "sha256-pbgQnaPBaYAvUaFNO9EkY5XCS7ylVgF2CwyWo8Cy+Po=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "C++ linear algebra library";
    homepage = "https://arma.sourceforge.net";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "C++ linear algebra library";
    homepage = "https://arma.sourceforge.net";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      juliendehos
    ];
  };
}
