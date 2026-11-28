{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  bison,
  flex,
  bitwuzla,
  cvc5,
  z3,
  gmp,
  mpfr,
  gtest,
}:

stdenv.mkDerivation {
  pname = "smt-switch";
  version = "1.1.6-unstable-2026-09-21";

  # Includes the CMake package export missing from v1.1.6. Newer main
  # requires cvc5 >= 1.4.0, while nixpkgs currently provides 1.3.4.
  src = fetchFromGitHub {
    owner = "stanford-centaur";
    repo = "smt-switch";
    rev = "9fb546fa1a29a7365837ceed1e49c58605610ce0";
    hash = "sha256-4WHcCbkvhKCwamf5DMDeO14AO16azhsNTdeHeIKOHKY=";
  };

  # Backport upstream b576401ec5ddf284a5896d590b0ce3de75525469 (#713)
  # and 5804fb40a13eec0258c4470323b075e78fd67f43 (#939): exact Z3
  # term/sort equality and reference-counted BVComp construction.
  patches = [ ./fix-z3-identity-and-bvcomp.patch ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    bison
    flex
  ];
  propagatedBuildInputs = [
    bitwuzla
    cvc5
    z3
    gmp
    mpfr
  ];
  checkInputs = [ gtest ];

  postPatch = ''
    # Shared Bitwuzla already resolves its SAT backend dependencies. Do not
    # require the static build's library names or re-link its private deps.
    substituteInPlace cmake/FindBitwuzla.cmake \
      --replace-fail "set(_bitwuzla_libraries bitwuzla bitwuzlals bitwuzlabv bitwuzlabb)" \
        "set(_bitwuzla_libraries bitwuzla)" \
      --replace-fail "if(_bitwuzla_needs_cadical)" \
        "if(FALSE)" \
      --replace-fail "foreach(_bitwuzla_dep IN LISTS _bitwuzla_stated_deps)" \
        "foreach(_bitwuzla_dep IN ITEMS)"

    # Nixpkgs' shared cvc5 target does not export private dependencies.
    # CaDiCaL and LibPoly are resolved in libcvc5; linking the static
    # cadical/picpoly/picpolyxx archives again is unnecessary and unsafe.
    substituteInPlace cvc5/CMakeLists.txt \
      --replace-fail "find_package(CaDiCaL REQUIRED)" "" \
      --replace-fail "target_link_libraries(smt-switch-cvc5 CaDiCaL::cadical)" ""
    substituteInPlace cmake/SmtSwitchConfig.cmake.in \
      --replace-fail "find_dependency(CaDiCaL)" ""
  '';

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=17"
    "-DSMT_SWITCH_LIB_TYPE=SHARED"
    "-DBUILD_BITWUZLA=ON"
    "-DBUILD_CVC5=ON"
    "-DBUILD_Z3=ON"
    "-DSMTLIB_READER=ON"
    "-DBUILD_TESTS=ON"
    "-DSYSTEM_GTEST=ON"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DBitwuzla_ROOT=${bitwuzla}"
    "-Dcvc5_ROOT=${cvc5}"
    "-DZ3_ROOT=${z3}"
    "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON"
  ];

  doCheck = true;

  meta = {
    description = "Solver-agnostic C++ API for SMT solving";
    homepage = "https://github.com/stanford-centaur/smt-switch";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mjliiii ];
  };
}
