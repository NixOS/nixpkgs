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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "yahoojapan";
    repo = "NGT";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2cCuVeg7y3butTIAQaYIgx+DPqIFEA2qqVe3exAoAY8=";
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
