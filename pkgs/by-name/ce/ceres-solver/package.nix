{
  lib,
  stdenv,
  config,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  cudaPackages,

  # buildInputs
  gflags,

  # propagatedBuildInputs
  eigen,
  glog,
  blas,
  metis,
  suitesparse,

  # passthru
  nix-update-script,

  enableStatic ? stdenv.hostPlatform.isStatic,
  withBlas ? true,
  cudaSupport ? config.cudaSupport,
}:
let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "ceres-solver";
  version = "2.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ceres-solver";
    repo = "ceres-solver";
    tag = finalAttrs.version;
    hash = "sha256-5SdHXcgwTlkDIUuyOQgD8JlAElk7aEWcFo/nyeOgN/k=";
  };

  outputs = [
    "out"
    "dev"
  ];

  # https://github.com/ceres-solver/ceres-solver/blob/85331393dc0dff09f6fb9903ab0c4bfa3e134b01/CMakeLists.txt#L251-L252
  postPatch = lib.optionalString cudaSupport ''
    nixLog "patching $PWD/CMakeLists.txt to remove hardcoded CUDA architectures"
    substituteInPlace "$PWD/CMakeLists.txt" \
      --replace-fail \
        'set(CMAKE_CUDA_ARCHITECTURES' \
        '# set(CMAKE_CUDA_ARCHITECTURES'
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs =
    lib.optionals finalAttrs.doCheck [
      gflags
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
      cudaPackages.libcublas
      cudaPackages.libcusolver
      cudaPackages.libcusparse
    ];

  propagatedBuildInputs = [
    eigen
    glog
  ]
  ++ lib.optionals withBlas [
    blas
    metis
    suitesparse
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!enableStatic))
    (lib.cmakeBool "USE_CUDA" cudaSupport)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ];

  # The Basel BUILD file conflicts with the cmake build directory on
  # case-insensitive filesystems, eg. darwin.
  preConfigure = ''
    rm BUILD
  '';

  doCheck = false;
  checkTarget = "test";

  preCheck =
    let
      skippedTests = lib.concatStringsSep ":" [
        # Failing (with more or less consistency) due to floating-point tolerance issues.
        # Upstream issue: https://github.com/ceres-solver/ceres-solver/issues/1062
        "Polynomial.NullPointerAsImaginaryPartWorks"
        "Polynomial.PolynomialNullPointerAsImaginaryPartWorks"
        "Polynomial.QuarticPolynomialWithTwoClustersOfCloseRootsWorks"
        "Polynomial.QuarticPolynomialWithTwoZeroRootsWorks"
        "Polynomial.QuarticPolynomialWorks"
      ];
    in
    ''
      export GTEST_FILTER="-${skippedTests}"
    '';

  passthru = {
    tests.withTests = finalAttrs.finalPackage.overrideAttrs {
      doCheck = true;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "C++ library for modeling and solving large, complicated optimization problems";
    license = lib.licenses.bsd3;
    homepage = "http://ceres-solver.org";
    downloadPage = "https://github.com/ceres-solver/ceres-solver";
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [ giogadi ];
    platforms = lib.platforms.unix;
  };
})
