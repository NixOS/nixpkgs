{ stdenv
, lib
, fetchFromGitHub
, cmake
, mpi
, blas
, gfortran
, llvmPackages
, gpuBackend ? "none"
, cudaPackages
, rocmPackages
}:

assert builtins.elem gpuBackend [ "none" "cuda" "rocm" ];

stdenv.mkDerivation rec {
  pname = "spla";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "eth-cscs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-71QpwTsRogH+6Bik9DKwezl9SqwoLxQt4SZ7zw5X6DE=";
  };

  postPatch = ''
    substituteInPlace src/gpu_util/gpu_blas_api.hpp \
      --replace '#include <rocblas.h>' '#include <rocblas/rocblas.h>'
  '';

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    blas
  ]
  ++ lib.optional (gpuBackend == "cuda") cudaPackages.cudatoolkit
  ++ lib.optionals (gpuBackend == "rocm") [
    rocmPackages.clr
    rocmPackages.rocblas
  ] ++ lib.optional stdenv.isDarwin llvmPackages.openmp
  ;

  propagatedBuildInputs = [ mpi ];

  cmakeFlags = [
    "-DSPLA_OMP=ON"
    "-DSPLA_FORTRAN=ON"
    "-DSPLA_INSTALL=ON"
    # Required due to broken CMake files
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optional (gpuBackend == "cuda") "-DSPLA_GPU_BACKEND=CUDA"
  ++ lib.optional (gpuBackend == "rocm") [ "-DSPLA_GPU_BACKEND=ROCM" ]
  ;

  meta = with lib; {
    description = "Specialized Parallel Linear Algebra, providing distributed GEMM functionality for specific matrix distributions with optional GPU acceleration";
    homepage = "https://github.com/eth-cscs/spla";
    license = licenses.bsd3;
    maintainers = [ maintainers.sheepforce ];#
  };
}
