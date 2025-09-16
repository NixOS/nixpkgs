{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  eigen,
  libxml2,
  mpi,
  python3Packages,
  petsc,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "3.2.0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "precice";
    rev = "6ee3e347843d4d3c416a32917f6505d35b822445";
    hash = "sha256-BxNAbpeLqJPzQ9dvvgC9jJQQFBdVMunSqIekz7SIHv4=";
  };

  cmakeFlags = [
    (lib.cmakeBool "PRECICE_PETScMapping" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    eigen
    libxml2
    mpi
    petsc
    python3Packages.python
    python3Packages.numpy
  ];

  meta = {
    description = "PreCICE stands for Precise Code Interaction Coupling Environment";
    homepage = "https://precice.org/";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ Scriptkiddi ];
    mainProgram = "binprecice";
    platforms = lib.platforms.unix;
  };
}
