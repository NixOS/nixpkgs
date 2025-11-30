{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  flex,
  bison,
  blas,
  lapack,
  cfitsio,
  wcslib,
  fftw,
  fftwFloat,
  readline,
  gsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "casacore";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "casacore";
    repo = "casacore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6zgTSGNKp2hHsh3GFl+o6ElavSNYnQvLsfb1xUrgNZI=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
    flex
    bison
  ];

  buildInputs = [
    blas
    lapack
    cfitsio
    wcslib
    fftw
    fftwFloat
    readline
    gsl
  ];

  enableParallelBuilding = true;

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_PYTHON3" false) # TODO: If/when we package python-casacore, this will change
  ];

  meta = {
    homepage = "https://casacore.github.io/casacore/";
    changelog = "https://github.com/casacore/casacore/blob/master/CHANGES.md";
    description = "Suite of C++ libraries for radio astronomy data processing";
    maintainers = with lib.maintainers; [ kiranshila ];
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.all;
  };
})
