{
  stdenv,
  lib,
  fetchFromGitHub,
  fftw,
  cmake,
  mpi,
  gfortran,
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

stdenv.mkDerivation rec {
  pname = "SpFFT";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "eth-cscs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hZdB/QcjL8rjvR1YZS+CHe5U5zxedpfDq6msMih4Elc=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ] ++ lib.optional (gpuBackend == "cuda") cudaPackages.cuda_nvcc;

  buildInputs =
    [
      fftw
      mpi
    ]
    ++ lib.optionals (gpuBackend == "cuda") [
      cudaPackages.libcufft
      cudaPackages.cuda_cudart
    ]
    ++ lib.optionals (gpuBackend == "rocm") [
      rocmPackages.clr
      rocmPackages.rocfft
      rocmPackages.hipfft
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  cmakeFlags =
    [
      "-DSPFFT_OMP=ON"
      "-DSPFFT_MPI=ON"
      "-DSPFFT_SINGLE_PRECISION=OFF"
      "-DSPFFT_FORTRAN=ON"
      # Required due to broken CMake files
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ]
    ++ lib.optional (gpuBackend == "cuda") "-DSPFFT_GPU_BACKEND=CUDA"
    ++ lib.optionals (gpuBackend == "rocm") [
      "-DSPFFT_GPU_BACKEND=ROCM"
      "-DHIP_ROOT_DIR=${rocmPackages.clr}"
    ];

  meta = with lib; {
    description = "Sparse 3D FFT library with MPI, OpenMP, CUDA and ROCm support";
    homepage = "https://github.com/eth-cscs/SpFFT";
    license = licenses.bsd3;
    maintainers = [ maintainers.sheepforce ];
    platforms = platforms.linux;
  };
}
