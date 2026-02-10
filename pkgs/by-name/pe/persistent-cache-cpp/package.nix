{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  boost,
  cmake,
  doxygen,
  gtest,
  leveldb,
  lomiri,
  pkg-config,
  python3,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "persistent-cache-cpp";
  version = "1.0.9";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/persistent-cache-cpp";
    rev = finalAttrs.version;
    hash = "sha256-1ETr4b0HEJIM6a4ObtKWtxn0y4gQy9fzBjE4QhMPGqU=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch = ''
    # Wrong concatenation
    substituteInPlace data/libpersistent-cache-cpp.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "\''${prefix}/lib"

    # Runs in parallel to other tests, limit to 1 thread
    substituteInPlace tests/headers/compile_headers.py \
      --replace 'multiprocessing.cpu_count()' '1'
  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/{headers,whitespace}/*.py
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    boost
    lomiri.cmake-extras
    leveldb
  ];

  nativeCheckInputs = [
    python3
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    # error: 'old_version' may be used uninitialized
    (lib.cmakeBool "Werror" false)
    # Defaults to static if not set
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Cache of key-value pairs with persistent storage for C++ 11";
    longDescription = ''
      A persistent cache for arbitrary (possibly large amount of data, such as
      image files) that is fast, scalable, and crash-proof.
    '';
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp";
    changelog = "https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "libpersistent-cache-cpp"
    ];
  };
})
