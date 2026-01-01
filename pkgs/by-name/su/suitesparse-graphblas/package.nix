{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gnum4,
}:

stdenv.mkDerivation rec {
  pname = "suitesparse-graphblas";
<<<<<<< HEAD
  version = "10.3.0";
=======
  version = "10.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wsvw/95eHF9KeduAgCfvNunRs86m4tiilxle26d1yJs=";
=======
    hash = "sha256-iZe5zHDaJtH1N6zXir38U2VJOD9fPChhwB7c3uCvjYc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Graph algorithms in the language of linear algebra";
    homepage = "https://people.engr.tamu.edu/davis/GraphBLAS.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = with lib.platforms; unix;
=======
  meta = with lib; {
    description = "Graph algorithms in the language of linear algebra";
    homepage = "https://people.engr.tamu.edu/davis/GraphBLAS.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ wegank ];
    platforms = with platforms; unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
