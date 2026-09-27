{
  lib,
  testers,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lz4,
  pkg-config,
  python3,
  stdenv,
  unzip,
  llvmPackages,
  enablePython ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flann";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "flann-lib";
    repo = "flann";
    tag = finalAttrs.version;
    hash = "sha256-5GCz28CbnPDQhEz6axFiQZMmOasd2Rph4a/bMQ53T2Q=";
  };

  patches = [
    # Add "Requires:" to generated pkg-config file, see https://github.com/flann-lib/flann/pull/481
    ./pkg-config-requires.patch

    # Patch HDF5_INCLUDE_DIR -> HDF5_INCLUDE_DIRS.
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/flann/-/raw/debian/1.9.1+dfsg-9/debian/patches/0001-Updated-fix-cmake-hdf5.patch";
      sha256 = "yM1ONU4mu6lctttM5YcSTg8F344TNUJXwjxXLqzr5Pk=";
    })

    # Fix LZ4 string separator issue, see: https://github.com/flann-lib/flann/pull/480
    ./pkg-config-lz4-expand-list.patch
  ];

  cmakeFlags = lib.mapAttrsToList lib.cmakeBool {
    BUILD_EXAMPLES = false;
    BUILD_DOC = false;
    BUILD_TESTS = finalAttrs.finalPackage.doCheck;
    BUILD_MATLAB_BINDINGS = false;
    BUILD_PYTHON_BINDINGS = enablePython;
    BUILD_C_BINDINGS = true;
    USE_OPENMP = true;
    USE_MPI = false;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    unzip
  ];

  propagatedBuildInputs = [ lz4 ];

  buildInputs =
    lib.optional enablePython python3 ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://github.com/flann-lib/flann";
    license = lib.licenses.bsd3;
    pkgConfigModules = [ "flann" ];
    description = "Fast approximate nearest neighbor searches in high dimensional spaces";
    maintainers = with lib.maintainers; [ tmarkus ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
