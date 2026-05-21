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
  version = "0.21.2-unstable-2025-11-29";

  src = fetchFromGitHub {
    owner = "blend2d";
    repo = "blend2d";
    rev = "6dbc2cefbc996379e07104e34519a440b49b15d7";
    hash = "sha256-25moUXRikLCFDWcWy4SP2uAE02kyxlAf8PxZTMtnW9U=";
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
