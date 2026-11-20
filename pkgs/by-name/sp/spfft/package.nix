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
  testers,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "SpFFT";
  version = "1.1.1";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "eth-cscs";
    repo = "SpFFT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qc/omdRv7dW9NJUOczMZJKhc+Z/sXeIxv3SbpegAGdU=";
  };

  # Support absolute install dirs, required for split outputs
  postPatch = ''
    substituteInPlace cmake/SpFFT.pc.in \
      --replace-fail ''\'''${prefix}/@CMAKE_INSTALL_LIBDIR@' '@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail ''\'''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
    substituteInPlace src/CMakeLists.txt \
      --replace-fail '$<INSTALL_INTERFACE:include>' '$<INSTALL_INTERFACE:''${CMAKE_INSTALL_FULL_INCLUDEDIR}>' \
      --replace-fail '$<INSTALL_INTERFACE:include/spfft>' '$<INSTALL_INTERFACE:''${CMAKE_INSTALL_FULL_INCLUDEDIR}/spfft>'
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    mpi
  ]
  ++ lib.optionals (gpuBackend == "cuda") [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    fftw
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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  # exposes <mpi.h> for cmake config check
  propagatedBuildInputs = [ mpi ];

  cmakeFlags = [
    (lib.cmakeBool "SPFFT_OMP" true)
    (lib.cmakeBool "SPFFT_MPI" true)
    (lib.cmakeBool "SPFFT_SINGLE_PRECISION" false)
    (lib.cmakeBool "SPFFT_FORTRAN" true)
  ]
  ++ lib.optionals (gpuBackend == "cuda") [
    (lib.cmakeFeature "SPFFT_GPU_BACKEND" "CUDA")
  ]
  ++ lib.optionals (gpuBackend == "rocm") [
    (lib.cmakeFeature "SPFFT_GPU_BACKEND" "ROCM")
    (lib.cmakeFeature "HIP_ROOT_DIR" rocmPackages.clr.outPath)
  ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "SpFFT" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Sparse 3D FFT library with MPI, OpenMP, CUDA and ROCm support";
    homepage = "https://github.com/eth-cscs/SpFFT";
    changelog = "https://github.com/eth-cscs/SpFFT/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sheepforce ];
    pkgConfigModules = [ "SpFFT" ];
    platforms = lib.platforms.linux;
  };
})
