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
  mpi,
  adios2,
  hdf5,
  llvmPackages,
  mpiSupport ? false,
  adios2Support ? false,
  hdf5Support ? false,
}:
let
  casacorePackages = {
    adios2 = adios2.override {
      inherit mpi mpiSupport;
    };
    fftw = fftw.override {
      inherit mpi;
      enableMpi = mpiSupport;
    };
    fftwFloat = fftwFloat.override {
      inherit mpi;
      enableMpi = mpiSupport;
    };
    hdf5 = hdf5.override {
      inherit mpi mpiSupport;
      cppSupport = !mpiSupport;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "casacore";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "casacore";
    repo = "casacore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NOxuHMCuHGk9XuWXMwQTN6kOFDI0QuHMgfNRDdlPw44=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gfortran
    flex
    bison
  ]
  ++ lib.optional mpiSupport mpi;

  propagatedBuildInputs = [
    wcslib
    cfitsio
  ]
  ++ lib.optional hdf5Support casacorePackages.hdf5
  ++ lib.optional mpiSupport mpi
  ++ lib.optional adios2Support casacorePackages.adios2;

  buildInputs = [
    blas
    lapack
    casacorePackages.fftw
    casacorePackages.fftwFloat
    readline
    gsl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  patches = [
    # Fix the generated .pc file: set Requires from a variable instead of
    # leaving it empty, and remove hardcoded absolute cmake build paths from
    # Cflags (which would embed /nix/store paths from the build environment).
    ./casacore-pkgconfig.patch
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_PYTHON3" false)
    (lib.cmakeBool "USE_OPENMP" true)
    (lib.cmakeBool "USE_ADIOS2" adios2Support)
    (lib.cmakeBool "USE_HDF5" hdf5Support)
    (lib.cmakeBool "USE_MPI" mpiSupport)
    (lib.cmakeBool "PORTABLE" true)
    (lib.cmakeBool "USE_PCH" false)
    (lib.cmakeBool "BUILD_FFTPACK_DEPRECATED" true) # Needed for casacpp
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
