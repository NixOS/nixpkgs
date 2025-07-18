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
  eigen,
  carl-storm,
  replaceVars,
  tbb,
}:

let
  l3ppSrc = fetchFromGitHub {
    owner = "hbruintjes";
    repo = "l3pp";
    rev = "e4f8d7fe6c328849aff34d2dfd6fd592c14070d5";
    sha256 = "sha256-F6Y9V9zPGtFkSUR7WdrBBldoSmgna0NK8sXHIyGpoC0=";
  };
in
stdenv.mkDerivation rec {
  pname = "storm";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "moves-rwth";
    repo = "storm";
    rev = "${version}";
    sha256 = "sha256-8+9fAiMLoyuzmQpMN7XBIocF2DqrVB1yU8fdq8w5GtY=";
    fetchSubmodules = true;
  };

  patches = [
    (replaceVars ./dont-fetch-external.patch {
      inherit l3ppSrc;
    })
  ];

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
    eigen
    carl-storm
    tbb
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
    "-DSTORM_FORCE_SHIPPED_CARL=OFF"
    "-DSTORM_CARL_DIR_HINT=${carl-storm}/lib/cmake"
    "-DEIGEN3_INCLUDE_DIR=${eigen}/include/eigen3"
  ];

  cmakeTargets = [ "storm-cli" ];

  meta = with lib; {
    description = "Storm: modern probabilistic model checker";
    homepage = "https://www.stormchecker.org/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.astrobeastie ];
    platforms = platforms.linux ++ platforms.darwin;
    longDescription = ''
      Storm is a C++20 probabilistic model checker supporting various engines,
      input languages (PRISM, JANI, etc.), LTL/PCTL/CSL, and includes stormpy bindings.
    '';
  };
}
