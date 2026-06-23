{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gklib";
  version = "5.1.1-unstable-2025-07-15";

  src = fetchFromGitHub {
    owner = "KarypisLab";
    repo = "GKlib";
    rev = "6e7951358fd896e2abed7887196b6871aac9f2f8";
    hash = "sha256-jT0hT5Y3E8GnE8OJWzDj5rtz9s59sMEXLduUnBV0I0Y=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    (lib.cmakeBool "OPENMP" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # Turns off using clflush/sfence insns in gkuniq test app
    # https://github.com/KarypisLab/GKlib/issues/11#issuecomment-1532597211
    (lib.cmakeBool "NO_X86" (!stdenv.hostPlatform.isx86))
  ];

  meta = {
    description = "Library of various helper routines and frameworks used by many of the lab's software";
    homepage = "https://github.com/KarypisLab/GKlib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qbisi ];
    platforms = lib.platforms.all;
  };
})
