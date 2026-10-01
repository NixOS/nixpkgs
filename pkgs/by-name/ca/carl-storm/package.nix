{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  gmp,
  ginac,
  storm-eigen,
  replaceVars,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "carl-storm";
  version = "14.30";

  src = fetchFromGitHub {
    owner = "moves-rwth";
    repo = "carl-storm";
    tag = finalAttrs.version;
    hash = "sha256-vfcB1mBOoBIkL7X4E7ClLgyfh++of/dVN3iTOJFKtdY=";
    fetchSubmodules = true;
  };

  patches = [
    ./dont-fetch-external.patch
  ];

  nativeBuildInputs = [
    cmake
    ginac
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeFeature "EIGEN3_INCLUDE_DIR" "${storm-eigen}/include/eigen3")

  ];

  cmakeTargets = [ "lib_carl" ];

  buildInputs = [
    boost
    gmp
    storm-eigen
    gtest
  ];

  meta = {
    description = "CArL-Storm - the Computer ARithmetic and Logic library for the probabilistic model checker Storm.";
    homepage = "https://ths-rwth.github.io/carl/index.html";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.astrobeastie ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    longDescription = ''
      CArL-Storm - the Computer ARithmetic and Logic library for the probabilistic model checker Storm. CArL-Storm is based on the Carl library.
    '';
  };
})
