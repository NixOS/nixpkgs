{
  lib,
  testers,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  lz4,
  pkg-config,
  python3,
  stdenv,
  unzip,
  llvmPackages,
  gtest,
  hdf5,

  clangStdenv,

  enablePython ? false,

  flann,
}:

let
  hashes = {
    cloud = "sha256-PaUn4yZ4fuidu+iCOFAFj1172YU9GjP94x/2cYuMJEU=";
    sift10K = "sha256-nZK3YhIPDuIeHmH5bQ6IQRXwBT4du37vWaW3oBcXfxE=";
    sift10K_byte = "sha256-X2JckKNyxAa1aLvk4lVZuSc8P2Loox9zfaNQEzWVhN4=";
    sift100K = "sha256-qs9YIaZdv1JDNatz/YMYF6YTKcUUvkBdALlbev/zpbY=";
    sift100K_byte = "sha256-CXKpppiR3V+7ZcV+Ef40fxP8sm5ciiGizr3BG4GDBII=";
    brief100K = "sha256-bF81Kj86kH5wwducEEhMPoesHu2A3kshTCGjrgCqjUU=";
  };
  mkTestdata =
    name:
    fetchurl {
      name = "${name}.h5";
      url = "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/${name}.h5";
      hash = hashes.${name};
    };

  testdata = map mkTestdata (lib.attrNames hashes);
in
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

  # The LZ4 patch updates cmake_minimum_required to 3.12, but only for non-clang builds.
  # For clang builds (like Darwin), we need to manually update it.
  # ref. https://github.com/flann-lib/flann/pull/526 not merged yet
  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail "add_dependencies(test flann_ruby_spec)" ""

    ${lib.concatMapStringsSep "\n" (d: "cp -v ${toString d} test/${d.name}") testdata}
    chmod +w test/*.h5
  '';

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
    lib.optionals enablePython [ python3 ] ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  checkInputs = [
    gtest
    hdf5
  ];

  doCheck = true;

  # 'tests' target builds test, 'test' target runs them
  postBuild = lib.optionalString finalAttrs.finalPackage.doCheck ''
    make tests
  '';

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  passthru.tests = {
    flann-clang = flann.override {
      stdenv = clangStdenv;
    };
    flann-python = flann.override {
      enablePython = true;
    };
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
