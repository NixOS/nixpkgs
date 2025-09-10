{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "KarlsruheGraphGeneration";
    repo = "kagen";
    tag = "v${finalAttrs.version}";
    # use vendor libmorton and xxHash
    fetchSubmodules = true;
    hash = "sha256-FSlTNOQgwPGOn4mIVIgFejvU0dpyydomHYJOKPz1UjU=";
  };

  patches = [
    # replace asm by builtin function to ensure compatibility with arm64
    (fetchpatch2 {
      url = "https://github.com/KarlsruheGraphGeneration/KaGen/commit/cab9d5dc6cc256972e52675ad9c385524d40ecd9.patch?full_index=1";
      hash = "sha256-DCsuwUiE98UKZMxlUI9p36/wq486uHHrUphrIVqM+Cc=";
    })
  ];

  postPatch = ''
    substituteInPlace tests/CMakeLists.txt \
      --replace-fail "FetchContent_MakeAvailable(googletest)" "find_package(GTest REQUIRED)"\
      --replace-fail "set_property(DIRECTORY" "#set_property(DIRECTORY"

    substituteInPlace kagen/CMakeLists.txt \
      --replace-fail "OBJECT" ""
  '';

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

  postInstall = ''
    cmake --install . --component tools
  '';

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
