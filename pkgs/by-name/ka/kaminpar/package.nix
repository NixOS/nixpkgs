{
  cmake,
  fetchFromGitHub,
  git,
  lib,
  mpiCheckPhaseHook,
  mpi,
  nix-update-script,
  numactl,
  pkg-config,
  sparsehash,
  stdenv,
  tbb_2022_0,
}:
let
  kassert-src = fetchFromGitHub {
    owner = "kamping-site";
    repo = "kassert";
    rev = "988b7d54b79ae6634f2fcc53a0314fb1cf2c6a23";

    fetchSubmodules = true;
    hash = "sha256-CBglUfVl9lgEa1t95G0mG4CCj0OWnIBwk7ep62rwIAA=";
  };

  kagen-src = fetchFromGitHub {
    owner = "KarlsruheGraphGeneration";
    repo = "KaGen";
    rev = "70386f48e513051656f020360c482ce6bff9a24f";

    fetchSubmodules = true;
    hash = "sha256-5EvRPpjUZpmAIEgybXjNU/mO0+gsAyhlwbT+syDUr48=";
  };

  google-test-src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "5a37b517ad4ab6738556f0284c256cae1466c5b4";
    hash = "sha256-uwdRrw79be2N1bBILeVa6q/hzx8MXUG8dcR4DU/cskw=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kaminpar";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "KaHIP";
    repo = "KaMinPar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DHMh0dKhZzhg6KfwPoI5Wod3ZazRQ1GDJUyirbxyoB8=";
  };

  doCheck = true;
  strictDeps = true;

  nativeBuildInputs = [
    git
    pkg-config
    cmake
    mpi
  ];

  propagatedBuildInputs = [
    tbb_2022_0
    sparsehash
    mpi
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux numactl;

  __darwinAllowLocalNetworking = true;
  nativeCheckInputs = [ mpiCheckPhaseHook ];

  cmakeFlags = [
    (lib.cmakeBool "KAMINPAR_BUILD_DISTRIBUTED" true)
    (lib.cmakeBool "KAMINPAR_BUILD_WITH_MTUNE_NATIVE" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_KASSERT" "${kassert-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_KAGEN" "${kagen-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${google-test-src}")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parallel heuristic solver for the balanced k-way graph partitioning problem";
    homepage = "https://github.com/KaHIP/KaMinPar";
    changelog = "https://github.com/KaHIP/KaMinPar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [ dsalwasser ];
    mainProgram = "KaMinPar";
  };
})
