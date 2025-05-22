{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gnum4,
}:

stdenv.mkDerivation rec {
  pname = "suitesparse-graphblas";
  version = "10.0.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "GraphBLAS";
    rev = "v${version}";
    hash = "sha256-BesARhxqfi4GsgdYsJd5b1+TYme891PezhSouDfZXBo=";
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

  meta = with lib; {
    description = "Graph algorithms in the language of linear algebra";
    homepage = "https://people.engr.tamu.edu/davis/GraphBLAS.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ wegank ];
    platforms = with platforms; unix;
  };
}
