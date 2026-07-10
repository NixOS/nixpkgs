{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  llvmPackages,
}:

# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
stdenv.mkDerivation (finalAttrs: {
  pname = "onednn";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneDNN";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xJTllrKs6mPNM85ZqyHTHWKpVOtOghmg4ZRFAvQZ4WU=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  # Fixup bad cmake paths
  postInstall = ''
    substituteInPlace $out/lib/cmake/dnnl/dnnl-config.cmake \
      --replace "\''${PACKAGE_PREFIX_DIR}/" ""

    substituteInPlace $out/lib/cmake/dnnl/dnnl-targets.cmake \
      --replace "\''${_IMPORT_PREFIX}/" ""
  '';

  meta = {
    changelog = "https://github.com/uxlfoundation/oneDNN/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "http://uxlfoundation.github.io/oneDNN";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
