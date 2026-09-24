{
  lib,
  cmake,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "numkong";
  version = "7.8.1";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "NumKong";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RaEfrrPbr+BICT1EU/UGfFFWw2leO0eahz6Vo9/pBqE=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Portable mixed-precision math, linear-algebra, & retrieval library with 2000+ SIMD kernels for x86, Arm, RISC-V, LoongArch, Power, & WebAssembly";
    homepage = "https://github.com/ashvardanian/NumKong/";
    changelog = "https://github.com/ashvardanian/NumKong/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
