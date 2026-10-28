{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  fypp,
  gfortran,
  mpi,
  pkg-config,
  python3,

  # buildInputs
  blas,
  lapack,
  libxsmm,

  # nativeCheckInputs
  mpiCheckPhaseHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbcsr";
  version = "2.10.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cp2k";
    repo = "dbcsr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BgZmc81TzgU3ifv4RHh2pfjbkUyxMIIpBrHCtnLF3p0=";
  };

  patches = [
    # Explicitly export the C API symbols, otherwise hidden with GCC 16
    # https://github.com/cp2k/dbcsr/pull/1027
    (fetchpatch {
      name = "expose-c-api-procedures.patch";
      url = "https://github.com/cp2k/dbcsr/commit/a5d9bcfcd487e3181b981687334da1b89bc61dce.patch";
      hash = "sha256-a4glOtMx1EUzYdoQb66bZaRnCgatVFWTqvcQlvU3oIc=";
    })
  ];

  postPatch = ''
    patchShebangs .
  ''
  # Force build of shared library, otherwise just static.
  + ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail \
        'add_library(dbcsr ''${DBCSR_SRCS})' \
        'add_library(dbcsr SHARED ''${DBCSR_SRCS})' \
      --replace-fail \
        'add_library(dbcsr_c ''${DBCSR_C_SRCS})' \
        'add_library(dbcsr_c SHARED ''${DBCSR_C_SRCS})'
  ''
  # Avoid calling the fypp wrapper script with python again. The nix wrapper took care of that.
  + ''
    substituteInPlace cmake/fypp-sources.cmake \
      --replace-fail \
        'COMMAND ''${Python_EXECUTABLE} ''${FYPP_EXECUTABLE}' \
        'COMMAND ''${FYPP_EXECUTABLE}'
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    fypp
    gfortran
    mpi
    pkg-config
    python3
  ];

  buildInputs = [
    blas
    lapack
    libxsmm
  ];

  propagatedBuildInputs = [ mpi ];

  cmakeFlags = [
    (lib.cmakeBool "USE_OPENMP" true)
    (lib.cmakeFeature "USE_SMM" "libxsmm")
    (lib.cmakeBool "WITH_C_API" true)
    (lib.cmakeBool "BUILD_TESTING" true)
    (lib.cmakeFeature "TEST_OMP_THREADS" "2")
    (lib.cmakeFeature "TEST_MPI_RANKS" "2")
    (lib.cmakeBool "ENABLE_SHARED" true)
    (lib.cmakeBool "USE_MPI" true)
  ];

  nativeCheckInputs = [
    mpiCheckPhaseHook
  ];

  doCheck = true;

  meta = {
    description = "Distributed Block Compressed Sparse Row matrix library";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/cp2k/dbcsr";
    changelog = "https://github.com/cp2k/dbcsr/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
