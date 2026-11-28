{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  bison,
  flex,
  smt-switch,
  btor2tools,
  gmp,
  fmt,
  gtest,
}:

stdenv.mkDerivation {
  pname = "pono";
  version = "2.0.0-unstable-2026-09-20";

  # This snapshot uses the post-v1.1.6 CMake interface but predates the
  # smt-switch API updates that require cvc5 >= 1.4.0 on current main.
  src = fetchFromGitHub {
    owner = "stanford-centaur";
    repo = "pono";
    rev = "fa7f8ced98d624a733166f9915dd5cd20b4f9a27";
    hash = "sha256-rKiL844Y/BFR/H43kkB3QmglHSd/0gCyE4X4DoTnJaw=";
  };

  # Z3 prints byte-sized bitvectors as #xNN. Recognize hexadecimal zero
  # and all-ones values when extracting a sound partial-model cube.
  patches = [ ./fix-partial-model-hex-values.patch ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    bison
    flex
  ];
  # FlexLexer.h is a target-side header as well as flex being a build tool.
  buildInputs = [
    smt-switch
    btor2tools
    gmp
    fmt
    flex
  ];
  checkInputs = [ gtest ];

  postPatch = ''
    # btor2tools.dev installs include/btor2parser/btor2parser.h, not
    # include/btor2parser.h. The find module clears its cache, so fix its search.
    substituteInPlace cmake/FindBtor2Tools.cmake \
      --replace-fail "find_path(Btor2Tools_INCLUDE_DIR NAMES btor2parser.h)" \
        "find_path(Btor2Tools_INCLUDE_DIR NAMES btor2parser.h PATH_SUFFIXES btor2parser)"
  '';

  cmakeFlags = [
    "-DPONO_LIB_TYPE=SHARED"
    "-DPONO_STATIC_EXEC=NO"
    "-DWITH_Z3=ON"
    "-DSYSTEM_GTEST=ON"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DSmtSwitch_ROOT=${smt-switch}"
    "-DBtor2Tools_ROOT=${lib.getDev btor2tools}"
    "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON"
  ];

  doCheck = true;
  # Tests are EXCLUDE_FROM_ALL; the upstream check target builds them first.
  checkTarget = "check";
  preCheck = ''
    export CTEST_OUTPUT_ON_FAILURE=1
    export CTEST_PARALLEL_LEVEL=$NIX_BUILD_CORES
  '';

  meta = {
    description = "SMT-based model checker";
    homepage = "https://github.com/stanford-centaur/pono";
    license = lib.licenses.bsd3;
    mainProgram = "pono";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mjliiii ];
  };
}
