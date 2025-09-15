{
  lib,
  stdenv,
  fetchFromGitHub,
  mpiCheckPhaseHook,
  cmake,
  python3,
  gfortran,
  blas,
  lapack,
  dbcsr,
  fftw,
  libint,
  libvori,
  libxc,
  dftd4,
  simple-dftd3,
  tblite,
  mpi,
  gsl,
  scalapack,
  makeWrapper,
  libxsmm,
  spglib,
  which,
  pkg-config,
  plumed,
  zlib,
  hdf5-fortran,
  sirius,
  libvdwxc,
  spla,
  spfft,
  trexio,
  toml-f,
  greenx,
  gmp,
  enableElpa ? false,
  elpa,
  cudaPackages,
  rocmPackages,
  newScope,
  mctc-lib,
  jonquil,
  multicharge,
  mstore,
  test-drive,
  config,
  gpuBackend ? (
    if config.cudaSupport then
      "cuda"
    else if config.rocmSupport then
      "rocm"
    else
      "none"
  ),
  # Change to a value suitable for your target GPU.
  # see https://github.com/cp2k/cp2k/blob/master/CMakeLists.txt#L433
  hipTarget ? "gfx908",
  cudaTarget ? "80",
}:

assert builtins.elem gpuBackend [
  "none"
  "cuda"
  "rocm"
];

let
  grimmeCmake = lib.makeScope newScope (self: {
    mctc-lib = mctc-lib.override {
      buildType = "cmake";
      inherit (self) jonquil toml-f;
    };

    toml-f = toml-f.override {
      buildType = "cmake";
      inherit (self) test-drive;
    };

    dftd4 = dftd4.override {
      buildType = "cmake";
      inherit (self) mstore mctc-lib multicharge;
    };

    jonquil = jonquil.override {
      buildType = "cmake";
      inherit (self) toml-f test-drive;
    };

    mstore = mstore.override {
      buildType = "cmake";
      inherit (self) mctc-lib;
    };

    multicharge = multicharge.override {
      buildType = "cmake";
      inherit (self) mctc-lib mstore;
    };

    test-drive = test-drive.override { buildType = "cmake"; };

    simple-dftd3 = simple-dftd3.override {
      buildType = "cmake";
      inherit (self) mctc-lib mstore toml-f;
    };

    tblite = tblite.override {
      buildType = "cmake";
      inherit (self)
        mctc-lib
        mstore
        toml-f
        multicharge
        dftd4
        simple-dftd3
        ;
    };

    sirius = sirius.override {
      inherit (self)
        mctc-lib
        toml-f
        multicharge
        dftd4
        simple-dftd3
        ;
    };
  });

in
stdenv.mkDerivation rec {
  pname = "cp2k";
  version = "2025.2";

  src = fetchFromGitHub {
    owner = "cp2k";
    repo = "cp2k";
    rev = "v${version}";
    hash = "sha256-vfl5rCoFeGtYuZ7LcsVsESjKxFbN5IYDvBSzOqsd64w=";
    fetchSubmodules = true;
  };

  patches = [
    # Remove the build command line from the source.
    # This avoids dependencies to .dev inputs
    ./remove-compiler-options.patch

    # Fix pkg-config path generation
    ./pkgconfig.patch
  ];

  nativeBuildInputs = [
    python3
    cmake
    which
    makeWrapper
    pkg-config
    gfortran
  ]
  ++ lib.optional (gpuBackend == "cuda") cudaPackages.cuda_nvcc;

  buildInputs = [
    fftw
    gsl
    libint
    libvori
    libxc
    libxsmm
    mpi
    spglib
    scalapack
    blas
    lapack
    dbcsr
    plumed
    zlib
    hdf5-fortran
    spla
    spfft
    libvdwxc
    trexio
    greenx
    gmp
    grimmeCmake.dftd4
    grimmeCmake.simple-dftd3
    grimmeCmake.tblite
    grimmeCmake.sirius
    grimmeCmake.toml-f
  ]
  ++ lib.optional enableElpa elpa
  ++ lib.optionals (gpuBackend == "cuda") [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.cuda_nvrtc
  ]
  ++ lib.optionals (gpuBackend == "rocm") [
    rocmPackages.clr
    rocmPackages.rocm-core
    rocmPackages.hipblas
    rocmPackages.hipfft
    rocmPackages.rocblas
  ];

  propagatedBuildInputs = [ (lib.getBin mpi) ];
  propagatedUserEnvPkgs = [ mpi ];

  postPatch = ''
    patchShebangs tools exts/dbcsr/tools/build_utils exts/dbcsr/.cp2k
    substituteInPlace exts/build_dbcsr/Makefile \
      --replace '/usr/bin/env python3' '${python3}/bin/python' \
      --replace 'SHELL = /bin/sh' 'SHELL = bash'
  '';

  cmakeFlags = [
    (lib.strings.cmakeBool "CP2K_USE_DFTD4" true)
    (lib.strings.cmakeBool "CP2K_USE_TBLITE" true)
    (lib.strings.cmakeBool "CP2K_USE_FFTW3" true)
    (lib.strings.cmakeBool "CP2K_USE_HDF5" true)
    (lib.strings.cmakeBool "CP2K_USE_LIBINT2" true)
    (lib.strings.cmakeBool "CP2K_USE_LIBXC" true)
    (lib.strings.cmakeBool "CP2K_USE_MPI" true)
    (lib.strings.cmakeBool "CP2K_USE_VORI" true)
    (lib.strings.cmakeBool "CP2K_USE_TREXIO" true)
    (lib.strings.cmakeBool "CP2K_USE_SPGLIB" true)
    (lib.strings.cmakeBool "CP2K_USE_SPLA" true)
    (lib.strings.cmakeBool "CP2K_USE_LIBXSMM" true)
    (lib.strings.cmakeBool "CP2K_USE_SIRIUS" true)
    (lib.strings.cmakeBool "CP2K_USE_LIBVDWXC" true)
    (lib.strings.cmakeBool "CP2K_USE_PLUMED" true)
    (lib.strings.cmakeBool "CP2K_USE_GREENX" true)
    (lib.strings.cmakeBool "CP2K_USE_ELPA" enableElpa)
    (lib.strings.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ]
  ++ lib.optionals (gpuBackend == "rocm") [
    (lib.strings.cmakeFeature "CP2K_USE_ACCEL" "HIP")
    (lib.strings.cmakeFeature "CMAKE_HIP_ARCHITECTURES" hipTarget)
  ]
  ++ lib.optionals (gpuBackend == "cuda") [
    (lib.strings.cmakeFeature "CP2K_USE_ACCEL" "CUDA")
    (lib.strings.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaTarget)
  ];

  nativeCheckInputs = [
    mpiCheckPhaseHook
  ];

  passthru = {
    inherit mpi;
  };

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    mkdir -p $out/share/cp2k
    cp -r ../data/* $out/share/cp2k

    for i in $out/bin/*; do
      wrapProgram $i \
        --set-default CP2K_DATA_DIR $out/share/cp2k \
        --set-default OMP_NUM_THREADS 1
    done
  '';

  doInstallCheck = gpuBackend == "none";

  installCheckPhase = ''
    runHook preInstallCheck

    for TEST in $out/bin/{dbt_tas,dbt,libcp2k,parallel_rng_types,gx_ac}_unittest.psmp; do
      mpirun -n 2 $TEST
    done

    runHook postInstallCheck
  '';

  meta = {
    description = "Quantum chemistry and solid state physics program";
    homepage = "https://www.cp2k.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sheepforce ];
    platforms = [ "x86_64-linux" ];
  };
}
