{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  openblas,
  enableAVX ? stdenv.hostPlatform.avxSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "NGT";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "NGT-labs";
    repo = "NGT";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-GLCAyLUYdCQHnJzFC75tzqhy5gsoxZ8/vQBME3Ah2Do=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    llvmPackages.openmp
    openblas
  ];

  env = {
    NIX_ENFORCE_NO_NATIVE = !enableAVX;
    __AVX2__ = if enableAVX then 1 else 0;
  };

  meta = {
    homepage = "https://github.com/NGT-labs/NGT";
    description = "Nearest Neighbor Search with Neighborhood Graph and Tree for High-dimensional Data";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomberek ];
  };
})
