{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  boost,
  capnproto,
  doxygen,
  flex,
  pkg-config,
  python3,
  sphinx,
  onetbb,
  buildPackages,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "naja";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "najaeda";
    repo = "naja";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OTQA8Uukhjr0Cy1zqMrxy+wke5cBFFx0OjoenxTBW2Q=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  postPatch = ''
    # This is a find module, not a config module, so this doesn't make it get automatically picked up by CMake hooks,
    # but it's better than dumping it at $out/cmake, and this makes it get moved to dev output
    substituteInPlace cmake/CMakeLists.txt \
      --replace-fail 'DESTINATION cmake' 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}/cmake'

    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.21)" \
      "cmake_minimum_required(VERSION 4.0)"
  ''
  # disable building tests for cross build
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'enable_testing()' "" \
      --replace-fail 'add_subdirectory(test)' ""
    substituteInPlace thirdparty/yosys-liberty/CMakeLists.txt \
      --replace-fail 'add_subdirectory(test)' ""
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    patchShebangs --build test/test_utils/diff_files.py
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-character-conversion"
    ]
  );

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    flex
    pkg-config
    sphinx
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    python3 # test scripts
  ];

  buildInputs = [
    boost
    capnproto # cmake modules
    flex # include dir
    onetbb
    python3
  ];

  cmakeFlags = [
    # provide correct executables for cross
    (lib.cmakeFeature "Python3_EXECUTABLE" (lib.getExe python3.pythonOnBuildForHost))
    # TODO: remove these once capnp cross is fixed properly
    (lib.cmakeFeature "CAPNP_EXECUTABLE" (lib.getExe' buildPackages.capnproto "capnp"))
    (lib.cmakeFeature "CAPNPC_CXX_EXECUTABLE" (lib.getExe' buildPackages.capnproto "capnpc-c++"))
  ];

  doCheck = true;

  # Disable Darwin failing tests (SIGTRAP)
  env.GTEST_FILTER = lib.optionalString stdenv.hostPlatform.isDarwin "-${
    lib.concatStringsSep ":" [
      "BNETests.blockedNormalizeNodeDeletionOrphanNodeRemoval"
      "BNETests.normalizeNodeDeletion"
      "ConstantPropagationTests.TestConstantPropagationAND_Hierarchical_duplicated_nested_actions"
      "LoadlessRemoveLogicTests.simple_2_loadless_2_levels"
      "LoadlessRemoveLogicTests.simple_2_loadless_3_levels_bne"
      "ReductionOptTests.testTruthTablesMap_bne"
    ]
  }";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Structural Netlist API (and more) for EDA post synthesis flow development";
    homepage = "https://github.com/najaeda/naja";
    license = lib.licenses.asl20;
    teams = [ lib.teams.ngi ];
    mainProgram = "naja_edit";
    platforms = lib.platforms.all;
  };
})
