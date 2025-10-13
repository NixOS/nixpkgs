{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mpi,
  mpiCheckPhaseHook,
  ctestCheckHook,
  gfortran,
  blas,
  lapack,
  gsl,
  libxc,
  hdf5,
  spglib,
  spfft,
  spla,
  costa,
  umpire,
  scalapack,
  boost,
  eigen,
  libvdwxc,
  dftd4,
  simple-dftd3,
  mctc-lib,
  jonquil,
  toml-f,
  multicharge,
  enablePython ? false,
  pythonPackages ? null,
  llvmPackages,
  cudaPackages,
  rocmPackages,
  config,
  gpuBackend ? (
    if config.cudaSupport then
      "cuda"
    else if config.rocmSupport then
      "rocm"
    else
      "none"
  ),
}:

assert builtins.elem gpuBackend [
  "none"
  "cuda"
  "rocm"
];
assert enablePython -> pythonPackages != null;

stdenv.mkDerivation {
  pname = "SIRIUS";
  version = "7.8.0-unstable-2025-07-23";

  src = fetchFromGitHub {
    owner = "electronic-structure";
    repo = "SIRIUS";
    rev = "258c8c6543af0350ac002a52fbe18221ea275590";
    hash = "sha256-HHt3iw3muIGz86NmI9p6yuv7jrXoiz/83qTTueU7Lpk=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
  ]
  ++ lib.optional (gpuBackend == "cuda") cudaPackages.cuda_nvcc;

  buildInputs = [
    blas
    lapack
    gsl
    libxc
    hdf5
    umpire
    mpi
    spglib
    spfft
    spla
    costa
    scalapack
    boost
    eigen
    libvdwxc
    jonquil
    simple-dftd3
    dftd4
    mctc-lib
    toml-f
    multicharge
  ]
  ++ lib.optionals (gpuBackend == "cuda") [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_profiler_api
    cudaPackages.cudatoolkit
    cudaPackages.libcublas
  ]
  ++ lib.optionals (gpuBackend == "rocm") [
    rocmPackages.clr
    rocmPackages.rocblas
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ]
  ++ lib.optionals enablePython (
    with pythonPackages;
    [
      python
      pybind11
    ]
  );

  propagatedBuildInputs = [
    (lib.getBin mpi)
  ]
  ++ lib.optionals enablePython (
    with pythonPackages;
    [
      mpi4py
      voluptuous
      numpy
      h5py
      scipy
      pyyaml
    ]
  );

  CXXFLAGS = [
    # GCC 13: error: 'uintptr_t' in namespace 'std' does not name a type
    "-include cstdint"
  ];

  cmakeFlags = [
    "-DSIRIUS_USE_SCALAPACK=ON"
    "-DSIRIUS_USE_VDWXC=ON"
    "-DSIRIUS_CREATE_FORTRAN_BINDINGS=ON"
    "-DSIRIUS_USE_OPENMP=ON"
    "-DSIRIUS_USE_DFTD3=ON"
    "-DSIRIUS_USE_DFTD4=ON"
    "-DBUILD_TESTING=ON"
  ]
  ++ lib.optionals (gpuBackend == "cuda") [
    "-DSIRIUS_USE_CUDA=ON"
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ]
  ++ lib.optionals (gpuBackend == "rocm") [
    "-DSIRIUS_USE_ROCM=ON"
    "-DHIP_ROOT_DIR=${rocmPackages.clr}"
  ]
  ++ lib.optionals enablePython [
    "-DSIRIUS_CREATE_PYTHON_MODULE=ON"
  ];

  doCheck = true;

  # Can not run parallel checks generally as it requires exactly multiples of 4 MPI ranks
  # Even cpu_serial tests had to be disabled as they require scalapack routines in the sandbox
  # and run into the same problem as MPI tests
  checkFlags = [
    "--label-exclude"
    "integration_test"
  ];

  nativeCheckInputs = [
    mpiCheckPhaseHook
    ctestCheckHook
  ];

  meta = with lib; {
    description = "Domain specific library for electronic structure calculations";
    homepage = "https://github.com/electronic-structure/SIRIUS";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
