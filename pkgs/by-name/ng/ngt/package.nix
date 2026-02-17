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
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "yahoojapan";
    repo = "NGT";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-T+ZFmvak1ZfY7I/9QKpC7qqXLq/tBdy+KUjx/0twceg=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    llvmPackages.openmp
    openblas
  ];

  NIX_ENFORCE_NO_NATIVE = !enableAVX;
  __AVX2__ = if enableAVX then 1 else 0;

  meta = {
    homepage = "https://github.com/yahoojapan/NGT";
    description = "Nearest Neighbor Search with Neighborhood Graph and Tree for High-dimensional Data";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomberek ];
  };
})
