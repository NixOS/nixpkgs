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
  libdwarf-lite,
  pkg-config,
  python3,
  tbb_2021_11,
  buildPackages,
}:
stdenv.mkDerivation {
  pname = "naja";
  version = "0-unstable-2025-01-13";

  src = fetchFromGitHub {
    owner = "najaeda";
    repo = "naja";
    rev = "ffc29daa22e02565b2a0a108f8e65236cdee413a";
    hash = "sha256-XGlgSUHSpHxNrms50pOQ9eoGZ6y79Rbm/sDYW2C4qsg=";
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

  nativeBuildInputs =
    [
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
    libdwarf-lite
    tbb_2021_11
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_LIBDWARF" true)
    (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_ZSTD" true)
    # provide correct executables for cross
    (lib.cmakeFeature "Python3_EXECUTABLE" (lib.getExe python3.pythonOnBuildForHost))
    # TODO: remove these once capnp cross is fixed properly
    (lib.cmakeFeature "CAPNP_EXECUTABLE" (lib.getExe' buildPackages.capnproto "capnp"))
    (lib.cmakeFeature "CAPNPC_CXX_EXECUTABLE" (lib.getExe' buildPackages.capnproto "capnpc-c++"))
  ];

  doCheck = true;

  postInstall = ''
    moveToOutput lib/libnaja_bne.so $lib
  '';

  meta = {
    description = "Structural Netlist API (and more) for EDA post synthesis flow development";
    homepage = "https://github.com/najaeda/naja";
    license = lib.licenses.asl20;
    maintainers = lib.teams.ngi.members;
    mainProgram = "naja_edit";
    platforms = lib.platforms.all;
  };
}
