{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gnum4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "suitesparse-graphblas";
  version = "10.5.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gjAxEqYLH6JNNETwA6N9K+MSO8h8W/KJ2jD9qMfE9ow=";
  };

  nativeBuildInputs = [
    cmake
    gnum4
  ];

  preConfigure = ''
    export HOME=$(mktemp -d)
  '';

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
