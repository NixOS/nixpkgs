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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "najaeda";
    repo = "naja";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cm9MwN60R/K2bL4FWpvusFmb2ENYEYg8NcMVgmeTj0c=";
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

    # Fix install location for bne library & headers
    # Remove when https://github.com/najaeda/naja/pull/278 merged & in release
    substituteInPlace src/bne/CMakeLists.txt \
      --replace-fail 'LIBRARY DESTINATION lib' 'LIBRARY DESTINATION ''${CMAKE_INSTALL_LIBDIR}' \
      --replace-fail 'PUBLIC_HEADER DESTINATION include' 'PUBLIC_HEADER DESTINATION ''${CMAKE_INSTALL_INCLUDEDIR}'
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
