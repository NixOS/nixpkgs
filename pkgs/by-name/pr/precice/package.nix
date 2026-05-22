{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  eigen,
  libxml2,
  mpi,
  python3Packages,
  petsc,
  ctestCheckHook,
  mpiCheckPhaseHook,
}:

assert petsc.mpiSupport;

stdenv.mkDerivation (finalAttrs: {
  pname = "precice";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "precice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/pMJd2ONEFi1Eo4RAL7viXGJf1i1b0Ccb/1y8m/ir0M=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
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

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  nativeCheckInputs = [
    ctestCheckHook
    mpiCheckPhaseHook
  ];

  disabledTests = [
    # Because preciceDt becomes very small. Test is likely to fail on other platform.
    "precice.Integration/Serial/Time/Explicit/ParallelCoupling/ReadWriteScalarDataWithSubcycling6400Steps"
  ];

  meta = {
    description = "PreCICE stands for Precise Code Interaction Coupling Environment";
    homepage = "https://precice.org/";
    license = with lib.licenses; [ lgpl3Only ];
    maintainers = [ ];
    mainProgram = "precice-tools";
    platforms = lib.platforms.unix;
  };
})
