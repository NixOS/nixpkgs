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
  tbb_2021,
  buildPackages,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "naja";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "najaeda";
    repo = "naja";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eKeb6V9u4huesQV4sq9GxIcxO2SVvMrUDeQaObCCags=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  # disable building tests for cross build
  postPatch =
    lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    python3 # test scripts
  ];

  buildInputs = [
    boost
    capnproto # cmake modules
    flex # include dir
    tbb_2021
    python3
  ];

  cmakeFlags = [
    # provide correct executables for cross
    (lib.cmakeFeature "Python3_EXECUTABLE" (lib.getExe python3.pythonOnBuildForHost))
    # TODO: remove these once capnp cross is fixed properly
    (lib.cmakeFeature "CAPNP_EXECUTABLE" (lib.getExe' buildPackages.capnproto "capnp"))
    (lib.cmakeFeature "CAPNPC_CXX_EXECUTABLE" (lib.getExe' buildPackages.capnproto "capnpc-c++"))
  ];

  postInstall = ''
    moveToOutput lib/libnaja_bne.so $lib
  '';

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
