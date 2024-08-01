{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "expressive-vector-engine";
  version = "2024-07-23";

  src = fetchFromGitHub {
    owner = "jfalcou";
    repo = "eve";
    rev = "df1cac9ccc510ce9841501fbbe6a166a6e7ad5ae";
    hash = "sha256-prtzUc1hlskQPv7FI5B0PEEVsq3nolYM48DjNO+bwxU=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  doCheck = false; #TODO

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput "lib/*/*.cmake" "$dev"
  '';

  meta = {
    description = ''
      Expressive Vector Engine - SIMD in C++ Goes Brrrr
    '';
    # TODO maintainer, nix@greenkeypartners.io?
  };
})
