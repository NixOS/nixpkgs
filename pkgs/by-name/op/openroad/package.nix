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
  nix-update-script,

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
  version = "26Q3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-jElAb8mM2lhGwa8wTONfQgs7esL9p1beAReJXAWns9o=";
  };

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    flex
    gitMinimal
    libsForQt5.wrapQtAppsHook
    pkg-config
    # Also needed as a build-time interpreter: CMake's find_package(Python)
    # (via the vendored third-party/slang-elab) needs python3 on PATH under
    # strictDeps, in addition to the libpython/headers pulled in via buildInputs.
    python3
    swig
    # tclsh is invoked directly to run etc/TclEncode.tcl at build time, in
    # addition to the libtcl/headers pulled in via buildInputs.
    tcl
  ];

  buildInputs = [
    boost
    cbc
    cimg
    clp
    cudd
    eigen
    # FlexLexer.h is needed at compile time in addition to the flex tool
    # itself (in nativeBuildInputs) for code generation.
    flex
    glpk
    gtest
    lcov
    lemon-graph
    libjpeg
    libsForQt5.qtbase
    libsForQt5.qtcharts
    libsForQt5.qtdeclarative
    libsForQt5.qtsvg
    or-tools
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
  ];

  postPatch = ''
    patchShebangs etc/
    # New in 26Q3: src/web's CMakeLists.txt invokes these scripts directly
    # as build steps (not just at runtime) to embed web/report assets.
    patchShebangs src/web/src/

    # Disable CutGTests because it misses core manager implementation
    # and fails under strict Nix linking. Filed as issue #9563.
    if [ -f src/cut/test/cpp/CMakeLists.txt ]; then
      echo "" > src/cut/test/cpp/CMakeLists.txt
    fi

    # OpenROAD vendors its own slang copy (third-party/slang-elab), separate
    # from nixpkgs' sv-lang_10 -- same fmt 12 fmt::format/fmt/core.h vs.
    # fmt/format.h split as sv-lang_10 (see its own package.nix comment for
    # the full explanation), same fix.
    if [ -d third-party/slang-elab/third_party/slang ]; then
      grep -rl '#include <fmt/core.h>' \
        --include='*.h' --include='*.cpp' \
        third-party/slang-elab/third_party/slang | \
        xargs sed -i 's|#include <fmt/core.h>|#include <fmt/format.h>|'
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

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ yosys ]}"
  ];

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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "OpenROAD's unified application implementing an RTL-to-GDS flow";
    homepage = "https://theopenroadproject.org";
    license = lib.licenses.bsd3;
    mainProgram = "openroad";
    maintainers = with lib.maintainers; [ hzeller ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
