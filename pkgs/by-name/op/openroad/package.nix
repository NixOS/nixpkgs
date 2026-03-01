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
  version = "26Q1";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-DMyoqDse9W6ahOajEINzFpgLsSKam/I1mQkRSSKepI8=";
  };

  patches = [
    (fetchpatch {
      name = "fix-openroad-commit-2a8b2c7.patch";
      url = "https://github.com/The-OpenROAD-Project/OpenROAD/commit/2a8b2c7dcda87679a69df323b2ada5f3a21554ea.patch";
      hash = "sha256-vgmVpr+vHbOd8UUUUyJ8sTKi0Y7CWYatF006WX4+zFI=";
    })
  ];

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
