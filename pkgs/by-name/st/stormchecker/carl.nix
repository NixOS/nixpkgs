{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  gmp,
  ginac,
  eigen,
  replaceVars,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "carl-storm";
  version = "14.30";

  src = fetchFromGitHub {
    owner = "moves-rwth";
    repo = "carl-storm";
    rev = "${version}";
    sha256 = "sha256-vfcB1mBOoBIkL7X4E7ClLgyfh++of/dVN3iTOJFKtdY=";
    fetchSubmodules = true;
  };

  patches = [
    ./carl-dont-fetch-external.patch
  ];

  nativeBuildInputs = [
    cmake
    ginac
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeFeature "EIGEN3_INCLUDE_DIR" "${eigen}/include/eigen3")

  ];

  cmakeTargets = [ "lib_carl" ];

  buildInputs = [
    boost
    gmp
    eigen
    gtest
  ];

  meta = with lib; {
    description = "CArL-Storm - the Computer ARithmetic and Logic library for the probabilistic model checker Storm.";
    homepage = "https://ths-rwth.github.io/carl/index.html";
    license = licenses.mit;
    maintainers = [ maintainers.astrobeastie ];
    platforms = platforms.linux ++ platforms.darwin;
    longDescription = ''
      CArL-Storm - the Computer ARithmetic and Logic library for the probabilistic model checker Storm. CArL-Storm is based on the Carl library.
    '';
  };
}
