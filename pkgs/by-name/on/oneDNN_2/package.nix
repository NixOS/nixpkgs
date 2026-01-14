{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
# oneDNN_2 is currently only consumed by rocmPackages.migraphx and likely
# to be dropped once migraphx can migrate to 3
stdenv.mkDerivation (finalAttrs: {
  pname = "oneDNN";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDNN";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-oMPBORAdL2rk2ewyUrInYVHYBRvuvNX4p4rwykO3Rhs=";
  };

  # Substituting for CMake 4 compat.
  # There's an upstream patch in v3 which does not cleanly apply.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" \
      "cmake_minimum_required(VERSION 2.8.12...3.13)"
  '';

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];

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
    changelog = "https://github.com/oneapi-src/oneDNN/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "https://01.org/oneDNN";
    license = lib.licenses.asl20;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.all;
  };
})
