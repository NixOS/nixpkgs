{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asmjit,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "blend2d";
  version = "0.21.2-unstable-2025-11-03";

  src = fetchFromGitHub {
    owner = "blend2d";
    repo = "blend2d";
    rev = "def0d1238c3e5d0983bb848e5676049d829e435b";
    hash = "sha256-b9DlgJNpMSLMM+xrM7sKVRH/DAoGHhOrwq5sw4OKH+k=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ (lib.cmakeFeature "ASMJIT_DIR" (toString asmjit.src)) ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "2D Vector Graphics Engine Powered by a JIT Compiler";
    homepage = "https://blend2d.com";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
}
