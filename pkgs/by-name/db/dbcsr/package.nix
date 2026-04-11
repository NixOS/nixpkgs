{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  mpiCheckPhaseHook,
  pkg-config,
  fypp,
  gfortran,
  blas,
  lapack,
  python3,
  libxsmm,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbcsr";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "cp2k";
    repo = "dbcsr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F6EvpsPAJJvmEZQKJDW2Mk4Yo8VsQCD4CE2IqxpjyN8=";
  };

  postPatch = ''
    patchShebangs .

    # Force build of shared library, otherwise just static.
    substituteInPlace src/CMakeLists.txt \
      --replace 'add_library(dbcsr ''${DBCSR_SRCS})' 'add_library(dbcsr SHARED ''${DBCSR_SRCS})' \
      --replace 'add_library(dbcsr_c ''${DBCSR_C_SRCS})' 'add_library(dbcsr_c SHARED ''${DBCSR_C_SRCS})'

    # Avoid calling the fypp wrapper script with python again. The nix wrapper took care of that.
    substituteInPlace cmake/fypp-sources.cmake \
      --replace 'COMMAND ''${Python_EXECUTABLE} ''${FYPP_EXECUTABLE}' 'COMMAND ''${FYPP_EXECUTABLE}'
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    gfortran
    python3
    cmake
    pkg-config
    fypp
  ];

  buildInputs = [
    blas
    lapack
    libxsmm
  ];

  propagatedBuildInputs = [ mpi ];

  cmakeFlags = [
    "-DUSE_OPENMP=ON"
    "-DUSE_SMM=libxsmm"
    "-DWITH_C_API=ON"
    "-DBUILD_TESTING=ON"
    "-DTEST_OMP_THREADS=2"
    "-DTEST_MPI_RANKS=2"
    "-DENABLE_SHARED=ON"
    "-DUSE_MPI=ON"
  ];

  checkInputs = [
    mpiCheckPhaseHook
  ];

  doCheck = true;

  meta = {
    description = "Distributed Block Compressed Sparse Row matrix library";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/cp2k/dbcsr";
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
