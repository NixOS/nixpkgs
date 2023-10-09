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
, scalapack
, boost
, eigen
, libvdwxc
, llvmPackages
, gpuBackend ? "none"
, cudaPackages
, hip
, rocblas
}:

assert builtins.elem gpuBackend [ "none" "cuda" "rocm" ];

stdenv.mkDerivation rec {
  pname = "SIRIUS";
  version = "7.4.3";

  src = fetchFromGitHub {
    owner = "electronic-structure";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s4rO+dePvtvn41wxCvbqgQGrEckWmfng7sPX2M8OPB0=";
  };

  postPatch = ''
    substituteInPlace src/gpu/acc_blas_api.hpp \
      --replace '#include <rocblas.h>' '#include <rocblas/rocblas.h>'
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
  ];

  buildInputs = [
    blas
    lapack
    gsl
    libxc
    hdf5
    spglib
    spfft
    spla
    costa
    scalapack
    boost
    eigen
    libvdwxc
  ]
  ++ lib.optional (gpuBackend == "cuda") cudaPackages.cudatoolkit
  ++ lib.optionals (gpuBackend == "rocm") [ hip rocblas ]
  ++ lib.optional stdenv.isDarwin llvmPackages.openmp
  ;

  propagatedBuildInputs = [ mpi ];

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
    "-DHIP_ROOT_DIR=${hip}"
  ];

  doCheck = true;

  # Can not run parallel checks generally as it requires exactly multiples of 4 MPI ranks
  checkPhase = ''
    runHook preCheck

    ctest --output-on-failure --label-exclude integration_test
    ctest --output-on-failure -L cpu_serial

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
