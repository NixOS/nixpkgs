{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, mpi
, mpiCheckPhaseHook
, openssh
, gfortran
, blas
, lapack
, gsl
, libxc
, hdf5
, spglib
, spfft
, spla
, costa
, umpire
, scalapack
, boost
, eigen
, libvdwxc
, llvmPackages
, cudaPackages
, rocmPackages
, config
, gpuBackend ? (
  if config.cudaSupport
  then "cuda"
  else if config.rocmSupport
  then "rocm"
  else "none"
)
}:

assert builtins.elem gpuBackend [ "none" "cuda" "rocm" ];

stdenv.mkDerivation rec {
  pname = "SIRIUS";
  version = "7.5.2";

  src = fetchFromGitHub {
    owner = "electronic-structure";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DYie6ufgZNqg7ohlIed3Bo+sqLKHOxWXTwAkea2guLk=";
  };


  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
  ] ++ lib.optional (gpuBackend == "cuda") cudaPackages.cuda_nvcc;

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
  ]
  ++ lib.optionals (gpuBackend == "cuda") [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_profiler_api
    cudaPackages.cudatoolkit
    cudaPackages.libcublas
  ] ++ lib.optionals (gpuBackend == "rocm") [
    rocmPackages.clr
    rocmPackages.rocblas
  ] ++ lib.optional stdenv.isDarwin llvmPackages.openmp
  ;

  propagatedBuildInputs = [ (lib.getBin mpi) ];

  CXXFLAGS = [
    # GCC 13: error: 'uintptr_t' in namespace 'std' does not name a type
    "-include cstdint"
  ];

  cmakeFlags = [
    "-DUSE_SCALAPACK=ON"
    "-DBUILD_TESTING=ON"
    "-DUSE_VDWXC=ON"
    "-DCREATE_FORTRAN_BINDINGS=ON"
    "-DUSE_OPENMP=ON"
    "-DBUILD_TESTING=ON"
  ]
  ++ lib.optionals (gpuBackend == "cuda") [
    "-DUSE_CUDA=ON"
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
  ]
  ++ lib.optionals (gpuBackend == "rocm") [
    "-DUSE_ROCM=ON"
    "-DHIP_ROOT_DIR=${rocmPackages.clr}"
  ];

  doCheck = true;

  # Can not run parallel checks generally as it requires exactly multiples of 4 MPI ranks
  # Even cpu_serial tests had to be disabled as they require scalapack routines in the sandbox
  # and run into the same problem as MPI tests
  checkPhase = ''
    runHook preCheck

    ctest --output-on-failure --label-exclude integration_test

    runHook postCheck
  '';

  nativeCheckInputs = [
    mpiCheckPhaseHook
    openssh
  ];

  meta = with lib; {
    description = "Domain specific library for electronic structure calculations";
    homepage = "https://github.com/electronic-structure/SIRIUS";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
