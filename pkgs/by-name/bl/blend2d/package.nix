{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asmjit,
}:

stdenv.mkDerivation {
  pname = "blend2d";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "blend2d";
    repo = "blend2d";
    rev = "717cbf4bc0f2ca164cf2f0c48f0497779241b6c5";
    hash = "sha256-L3wDsjy0cocncZqKLy8in2yirrFJoqU3tFBfeBxlhs0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ (lib.cmakeFeature "ASMJIT_DIR" (toString asmjit.src)) ];

  meta = {
    description = "2D Vector Graphics Engine Powered by a JIT Compiler";
    homepage = "https://blend2d.com";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
}
