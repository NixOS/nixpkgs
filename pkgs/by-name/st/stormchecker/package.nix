{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  cmake,
  boost,
  cln,
  gmp,
  ginac,
  automake,
  autoconf,
  glpk,
  hwloc,
  z3,
  xercesc,
  storm-eigen,
  carl-storm,
  substitute,
  tbb,
  spot-automata,
}:

let
  l3ppSrc = fetchFromGitHub {
    owner = "hbruintjes";
    repo = "l3pp";
    rev = "e4f8d7fe6c328849aff34d2dfd6fd592c14070d5";
    hash = "sha256-F6Y9V9zPGtFkSUR7WdrBBldoSmgna0NK8sXHIyGpoC0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "storm";
  version = "1.10.0-unstable-2025-07-02";

  src = fetchFromGitHub {
    owner = "moves-rwth";
    repo = "storm";
    rev = "c7448a2ee1c4db5d4bd892995768fa790247511b";
    hash = "sha256-U34tRdN4IGGq/39a5AmAYvuCTJE32btLbnxVK6T434o=";
    fetchSubmodules = true;
  };

  patches = [
    (substitute {
      src = ./dont-fetch-external.patch;
      substitutions = [
        "--subst-var-by"
        "l3ppSrc"
        "${l3ppSrc}"
      ];
    })
  ];

  dontDetectUnsubstitutedVars = true;

  nativeBuildInputs = [
    cmake
    automake
    autoconf
  ];

  buildInputs = [
    boost
    cln
    gmp
    ginac
    glpk
    hwloc
    z3
    xercesc
    storm-eigen
    carl-storm
    tbb
    spot-automata
  ];

  prePatch = ''
    substituteInPlace src/storm/adapters/eigen.h \
        --replace '<StormEigen/Eigen/Dense>' '<Eigen/Dense>' \
        --replace '<StormEigen/Eigen/Sparse>' '<Eigen/Sparse>' \
        --replace '<StormEigen/unsupported/Eigen/IterativeSolvers>' '<unsupported/Eigen/IterativeSolvers>'
  '';

  cmakeFlags = [
    "-DSTORM_LOAD_QVBS=OFF"
    "-DSTORM_USE_INTELTBB=ON"
    "-Dcarl_DIR=${carl-storm}/lib/cmake"
    "-DEIGEN3_INCLUDE_DIR=${storm-eigen}/include/eigen3"
  ];

  cmakeTargets = [ "storm-cli" ];

  meta = {
    description = "Storm: modern probabilistic model checker";
    homepage = "https://www.stormchecker.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.astrobeastie ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    longDescription = ''
      Storm is a C++20 probabilistic model checker supporting various engines,
      input languages (PRISM, JANI, etc.), LTL/PCTL/CSL, and includes stormpy bindings.
    '';
  };
})
