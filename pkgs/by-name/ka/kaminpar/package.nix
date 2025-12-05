{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  numactl,
  mpi,
  sparsehash,
  onetbb,
  kagen,
  kassert,
  gtest,
  mpiCheckPhaseHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kaminpar";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "KaHIP";
    repo = "KaMinPar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g343iIpKRclQ+hKdWEVbA7JVuHGBLSq40rK9YUBIy+o=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux numactl;

  propagatedBuildInputs = [
    kagen
    kassert
    mpi
    onetbb
    sparsehash
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "KAMINPAR_BUILD_DISTRIBUTED" true)
    (lib.cmakeBool "KAMINPAR_BUILD_WITH_MTUNE_NATIVE" false)
  ];

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    gtest
    mpiCheckPhaseHook
  ];

  meta = {
    description = "Parallel heuristic solver for the balanced k-way graph partitioning problem";
    homepage = "https://github.com/KaHIP/KaMinPar";
    changelog = "https://github.com/KaHIP/KaMinPar/releases/tag/v${finalAttrs.version}";
    mainProgram = "KaMinPar";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dsalwasser ];
  };
})
