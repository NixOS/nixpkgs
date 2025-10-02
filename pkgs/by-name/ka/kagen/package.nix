{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mpi,
  cgal_5,
  boost,
  gmp,
  mpfr,
  sparsehash,
  imagemagick,
  gtest,
  ctestCheckHook,
  mpiCheckPhaseHook,
  withExamples ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kagen";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "KarlsruheGraphGeneration";
    repo = "kagen";
    tag = "v${finalAttrs.version}";
    # use vendor libmorton and xxHash
    fetchSubmodules = true;
    hash = "sha256-2jXHHS9Siu6hXrYPIrZSOWe6D2PgsvrbMw/7Ykpc3wk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    mpi
    cgal_5
    sparsehash
    imagemagick
    # should be propagated by cgal
    boost
    gmp
    mpfr
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "KAGEN_USE_BUNDLED_GTEST" false)
    (lib.cmakeBool "KAGEN_BUILD_EXAMPLES" withExamples)
    (lib.cmakeBool "KAGEN_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    gtest
    ctestCheckHook
    mpiCheckPhaseHook
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # flaky tests on aarch64-darwin
    "test_rgg2d.2cores"
    "test_rgg2d.4cores"
  ];

  meta = {
    description = "Communication-free Massively Distributed Graph Generators";
    homepage = "https://github.com/KarlsruheGraphGeneration/KaGen";
    changelog = "https://github.com/KarlsruheGraphGeneration/KaGen/releases/tag/v${finalAttrs.version}";
    mainProgram = "KaGen";
    license = with lib.licenses; [
      bsd2
      mit
      # boost license
      lib.licenses.boost
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
