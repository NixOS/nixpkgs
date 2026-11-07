{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  carl-storm,
  maven,
  antlr4_8,
  jre,
  storm-eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "carl-parser";
  version = "0-unstable-2025-07-01";

  src = fetchFromGitHub {
    owner = "moves-rwth";
    repo = "carl-parser";
    rev = "d3d697c36be065599178acb519e5857e3b1c7dc5";
    hash = "sha256-RvJCQasDp9Wih8RyjkOOfk6O7sdiSpJzdh6kha48qKY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    maven
    jre
    antlr4_8
  ];

  patches = [ ./cmake.patch ];

  cmakeFlags = [
    "-Dcarl_DIR=${carl-storm}/lib/cmake"
    "-Dantlr4-runtime_DIR=${antlr4_8.runtime.cpp.dev}/lib/cmake/antlr4"
    (lib.cmakeFeature "EIGEN3_INCLUDE_DIR" "${storm-eigen}/include/eigen3")
    (lib.cmakeFeature "ANTLR4_INCLUDE_DIR" "${antlr4_8}/include/antlr4-runtime")
  ];

  buildInputs = [
    carl-storm
    antlr4_8.runtime.cpp
    storm-eigen
  ];

  meta = {
    description = "An ANTLR-based parser which is meant as an extension to CArL.";
    homepage = "https://github.com/moves-rwth/carl-parser";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.astrobeastie ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
