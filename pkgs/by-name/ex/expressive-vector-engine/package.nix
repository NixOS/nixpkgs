{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "expressive-vector-engine";
  version = finalAttrs.src.rev;

  src = fetchFromGitHub {
    owner = "jfalcou";
    repo = "eve";
    rev = "v2023.02.15";
    hash = "sha256-k7dDtLR9PoJp9SR0z4j6uNwm8JOJQiHXbr09kXtRJ7g=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  doCheck = false; #TODO

  enableParallelBuilding = true;

  meta = {
    description = ''
      Expressive Vector Engine - SIMD in C++ Goes Brrrr
    '';
    # TODO maintainer, nix@greenkeypartners.io?
  };
})
