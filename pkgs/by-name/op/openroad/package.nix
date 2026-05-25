{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  yaml-cpp,

  # nativeBuildInputs
  bison,
  cmake,
  doxygen,
  flex,
  gitMinimal,
  gtest,
  libsForQt5,
  pkg-config,
  swig,
  versionCheckHook,

  # buildInputs
  boost,
  cbc,
  cimg,
  clp,
  cudd,
  eigen,
  glpk,
  lcov,
  lemon-graph,
  libjpeg,
  or-tools,
  pcre,
  python3,
  re2,
  readline,
  spdlog,
  tcl,
  tclPackages,
  yosys,
  zlib,
  libx11,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openroad";
  version = "26Q2";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-dB9PfPlp6vZ9+Th8LJE65BW9YeuUL0G4JtjzQxg6UpQ=";
  };

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    flex
    gitMinimal
    gtest
    libsForQt5.wrapQtAppsHook
    pkg-config
    swig
  ];

  buildInputs = [
    boost
    cbc
    cimg
    clp
    cudd
    eigen
    glpk
    lcov
    lemon-graph
    libjpeg
    libsForQt5.qtbase
    libsForQt5.qtcharts
    libsForQt5.qtdeclarative
    libsForQt5.qtsvg
    or-tools
    pcre
    python3
    re2
    readline
    spdlog
    tcl
    tclPackages.tclreadline
    yosys
    zlib
    yaml-cpp
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libx11 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  patches = [
    # Fix UB in OpenSTA dcalc tests: fake Pin* pointers dereference via
    # PinIdLess comparator, crashing with GCC 15's hardened vector bounds check.
    # https://github.com/The-OpenROAD-Project/OpenSTA/pull/346
    (fetchpatch {
      url = "https://github.com/gonsolo/OpenSTA/commit/0e40b4f8a1c4b6af7225da31cd88a1d29d8a04a2.patch";
      hash = "sha256-W9USjqp/hL1s3w3nKVMo/a5aSkeQ4Lp7gqASbZSlo9Y=";
      stripLen = 1;
      extraPrefix = "src/sta/";
    })
    # Feature-test std::from_chars to fix aarch64-darwin build where
    # libcxx marks from_chars unavailable (macOS 26.0).
    # https://github.com/The-OpenROAD-Project/OpenSTA/commit/a5921d1ca
    (fetchpatch {
      url = "https://github.com/The-OpenROAD-Project/OpenSTA/commit/a5921d1ca964971ada83be2c7c65bb84504fe179.patch";
      hash = "sha256-j9BneXSIya/euYiol16swmrFkXTDZNTQwq3tPFkCLH0=";
      stripLen = 1;
      extraPrefix = "src/sta/";
    })
    # Replace deprecated sprintf with snprintf in Logger::error.
    # macOS Apple SDK 14.4+ marks sprintf as deprecated, breaking -Werror builds.
    # https://github.com/The-OpenROAD-Project/OpenROAD/pull/10127
    (fetchpatch {
      url = "https://github.com/The-OpenROAD-Project/OpenROAD/commit/2a9191bc5b2841a0c357886a2a1bc3ac0fe5271a.patch";
      hash = "sha256-lxFZvybfG0Qpg1TyKdfZhKLYI3DSCYDE54ta6EnDBDo=";
    })
  ];

  postPatch = ''
    patchShebangs etc/

    # Disable CutGTests because it misses core manager implementation
    # and fails under strict Nix linking. Filed as issue #9563.
    if [ -f src/cut/test/cpp/CMakeLists.txt ]; then
      echo "" > src/cut/test/cpp/CMakeLists.txt
    fi
  ''

  # Disable failing PSM tests on aarch64
  + lib.optionalString stdenv.hostPlatform.isAarch64 ''
    if [ -f src/psm/test/CMakeLists.txt ]; then
      echo "Patching PSM tests for aarch64..."
      sed -i -E 's/^[[:space:]]+(gcd_all_vss|gcd_em_test_vdd|insert_decap1|insert_decap_with_padding1)/    # \1/' src/psm/test/CMakeLists.txt
    fi
  '';

  cmakeFlags = [
    # Disable tests on Darwin to avoid discovery timeouts during build
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "USE_SYSTEM_BOOST" true)
    (lib.cmakeBool "USE_SYSTEM_ABC" false)
    (lib.cmakeBool "ABC_SKIP_TESTS" true)
    (lib.cmakeBool "USE_SYSTEM_OPENSTA" false)
    (lib.cmakeFeature "OPENROAD_VERSION" finalAttrs.version)
    (lib.cmakeBool "CMAKE_RULE_MESSAGES" false)
    (lib.cmakeFeature "TCL_HEADER" "${tcl}/include/tcl.h")
    (lib.cmakeFeature "TCL_LIBRARY" "${tcl}/lib/libtcl${stdenv.hostPlatform.extensions.sharedLibrary}")
    (lib.cmakeFeature "BOOST_ROOT" "${boost}")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DBOOST_STACKTRACE_GNU_SOURCE_NOT_REQUIRED -Wno-error=deprecated-declarations")
  ];

  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ yosys ]}" ];

  # Some tests are unstable on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  meta = {
    description = "OpenROAD's unified application implementing an RTL-to-GDS flow";
    homepage = "https://theopenroadproject.org";
    license = lib.licenses.bsd3;
    mainProgram = "openroad";
    maintainers = with lib.maintainers; [
      trepetti
      hzeller
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
