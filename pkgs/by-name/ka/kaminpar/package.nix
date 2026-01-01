{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch2,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmake,
  numactl,
  mpi,
  sparsehash,
  onetbb,
<<<<<<< HEAD
  kagen,
  kassert,
  gtest,
  mpiCheckPhaseHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kaminpar";
  version = "3.7.1";
=======
  gtest,
  mpiCheckPhaseHook,
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kaminpar";
  version = "3.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "KaHIP";
    repo = "KaMinPar";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-g343iIpKRclQ+hKdWEVbA7JVuHGBLSq40rK9YUBIy+o=";
  };

=======
    hash = "sha256-1azBj1DSEb7b8u+S51Sncn6EVMgu+SuFJcK4QVVhRk4=";
  };

  patches = [
    # require gtest to be preinstalled by default if building tests
    (fetchpatch2 {
      url = "https://github.com/KaHip/KaMinPar/commit/9cb9883eea076d11cffcf4b0d14bf1f4f95a00e4.patch?full_index=1";
      hash = "sha256-aUO5E0HTZqjfu5BUzyRdSZgyQYcE4PGqZaJvLD40sn8=";
    })
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux numactl;

  propagatedBuildInputs = [
<<<<<<< HEAD
    kagen
    kassert
    mpi
    onetbb
    sparsehash
=======
    mpi
    sparsehash
    onetbb
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "KAMINPAR_BUILD_DISTRIBUTED" true)
    (lib.cmakeBool "KAMINPAR_BUILD_WITH_MTUNE_NATIVE" false)
<<<<<<< HEAD
=======
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_KASSERT" "${kassert-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_KAGEN" "${kagen-src}")
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
