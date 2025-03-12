{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch2,
}:

stdenv.mkDerivation {
  pname = "gklib";
  # there is no released tag compatible of downstream metis 5.2.1
  # see https://github.com/KarypisLab/GKlib/issues/23
  version = "0-unstable-2023-03-27";

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "GKlib";
    rev = "8bd6bad750b2b0d90800c632cf18e8ee93ad72d7";
    hash = "sha256-tunepMLaRDR5FQVL/9S7/w6e1j+f2+pg01H/0/z/ZCI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "NO_X86" (!stdenv.hostPlatform.isx86))
    # force metis/parmetis to use a portable random number generator that will produce the same partitioning results on all systems
    (lib.cmakeBool "GKRAND" true)
  ];

  meta = {
    description = "Library of various helper routines and frameworks used by many of the lab's software";
    homepage = "https://github.com/KarypisLab/GKlib";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
