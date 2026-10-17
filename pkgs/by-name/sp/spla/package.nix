{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  mpi,
  blas,
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
  pname = "spla";
  version = "1.6.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eth-cscs";
    repo = "spla";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fNH1IOKV1Re8G7GH9Xfn3itR80eonTbEGKQRRD16/2k=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace src/gpu_util/gpu_blas_api.hpp \
      --replace-fail '#include <rocblas.h>' '#include <rocblas/rocblas.h>'
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    mpi
  ]
  ++ lib.optionals (gpuBackend == "cuda") [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    blas
  ]
  ++ lib.optionals (gpuBackend == "cuda") [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
  ]
  ++ lib.optionals (gpuBackend == "rocm") [
    rocmPackages.clr
    rocmPackages.rocblas
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  # needed for cmake config check
  propagatedBuildInputs = [ mpi ];

  cmakeFlags = [
    (lib.cmakeBool "SPLA_OMP" true)
    (lib.cmakeBool "SPLA_FORTRAN" true)
    (lib.cmakeBool "SPLA_INSTALL" true)
    # Required due to broken CMake files
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ]
  ++ lib.optionals (gpuBackend == "cuda") [ (lib.cmakeFeature "SPLA_GPU_BACKEND" "CUDA") ]
  ++ lib.optionals (gpuBackend == "rocm") [ (lib.cmakeFeature "SPLA_GPU_BACKEND" "ROCM") ];

  preFixup = ''
    substituteInPlace $out/lib/cmake/SPLA/SPLASharedTargets-release.cmake \
      --replace-fail "\''${_IMPORT_PREFIX}" "$out"
  '';

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "SPLA" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Specialized Parallel Linear Algebra, providing distributed GEMM functionality for specific matrix distributions with optional GPU acceleration";
    homepage = "https://github.com/eth-cscs/spla";
    changelog = "https://github.com/eth-cscs/spla/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sheepforce ];
    pkgConfigModules = [ "SPLA" ];
  };
})
