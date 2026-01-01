{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asmjit,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation {
  pname = "blend2d";
<<<<<<< HEAD
  version = "0.21.2-unstable-2025-11-03";
=======
  version = "0.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "blend2d";
    repo = "blend2d";
<<<<<<< HEAD
    rev = "def0d1238c3e5d0983bb848e5676049d829e435b";
    hash = "sha256-b9DlgJNpMSLMM+xrM7sKVRH/DAoGHhOrwq5sw4OKH+k=";
=======
    rev = "717cbf4bc0f2ca164cf2f0c48f0497779241b6c5";
    hash = "sha256-L3wDsjy0cocncZqKLy8in2yirrFJoqU3tFBfeBxlhs0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ (lib.cmakeFeature "ASMJIT_DIR" (toString asmjit.src)) ];

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "2D Vector Graphics Engine Powered by a JIT Compiler";
    homepage = "https://blend2d.com";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
}
