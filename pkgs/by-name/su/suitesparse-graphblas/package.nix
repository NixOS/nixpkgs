{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gnum4,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "suitesparse-graphblas";
  version = "10.5.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DHXIFD2q0jB2CZhSn2aN1gtCAbZ665Ar9ZcXn3EMwM0=";
  };

  nativeBuildInputs = [
    cmake
    gnum4
    writableTmpDirAsHomeHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "GRAPHBLAS_USE_JIT" (
      !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64)
    ))
  ];

  meta = {
    description = "Graph algorithms in the language of linear algebra";
    homepage = "https://people.engr.tamu.edu/davis/GraphBLAS.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = with lib.platforms; unix;
  };
})
