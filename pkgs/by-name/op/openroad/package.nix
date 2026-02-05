{
  lib,
  stdenv,
  fetchFromGitHub,
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
  abc-verifier,
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
    abc-verifier
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

  # This activates the namespace logic found in abc_namespaces.h
  env.NIX_CFLAGS_COMPILE = "-DABC_NAMESPACE=abc";

  # Linker flags for transitive dependencies of the static libabc.a
  # This avoids passing spaces/flags directly into CMake's ABC_LIBRARY variable
  env.NIX_LDFLAGS = "-lreadline -lrt";

  postPatch = ''
    patchShebangs etc/

    # C++20 Fixes
    sed -e '39i #include <cstdint>' -i src/gpl/src/placerBase.h
    sed -e '37i #include <cstdint>' -i src/gpl/src/routeBase.h
  ''
  # Disable failing PSM tests on aarch64
  + lib.optionalString stdenv.hostPlatform.isAarch64 ''
    if [ -f src/psm/test/CMakeLists.txt ]; then
      echo "Patching PSM tests for aarch64..."
      sed -i -E 's/^[[:space:]]+(gcd_all_vss|gcd_em_test_vdd|insert_decap1|insert_decap_with_padding1)/    # \1/' src/psm/test/CMakeLists.txt
    fi
  '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "USE_SYSTEM_BOOST" true)
    (lib.cmakeBool "USE_SYSTEM_ABC" true)
    (lib.cmakeFeature "ABC_INCLUDE_DIR" "${abc-verifier}/include")
    (lib.cmakeFeature "ABC_LIBRARY" "${abc-verifier}/lib/libabc.a")

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
