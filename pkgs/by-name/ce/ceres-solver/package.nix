{
  lib,
  stdenv,
  fetchFromGitHub,
  blas,
  cmake,
  config,
  cudaPackages,
  eigen,
  gflags,
  glog,
  suitesparse,
  metis,
  runTests ? false,
  enableStatic ? stdenv.hostPlatform.isStatic,
  withBlas ? true,
  enableCuda ? config.cudaSupport,
}@inputs:

let
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;
in

# gflags is required to run tests
assert runTests -> gflags != null;

effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "ceres-solver";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ceres-solver";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-5SdHXcgwTlkDIUuyOQgD8JlAElk7aEWcFo/nyeOgN/k=";
  };

  outputs = [
    "out"
    "dev"
  ];

  # https://github.com/ceres-solver/ceres-solver/blob/85331393dc0dff09f6fb9903ab0c4bfa3e134b01/CMakeLists.txt#L251-L252
  postPatch = lib.optionalString enableCuda ''
    nixLog "patching $PWD/CMakeLists.txt to remove hardcoded CUDA architectures"
    substituteInPlace "$PWD/CMakeLists.txt" \
      --replace-fail \
        'set(CMAKE_CUDA_ARCHITECTURES' \
        '# set(CMAKE_CUDA_ARCHITECTURES'
  '';

  nativeBuildInputs = [ cmake ] ++ lib.optionals enableCuda [ cudaPackages.cuda_nvcc ];

  buildInputs =
    lib.optional runTests gflags
    ++ lib.optionals enableCuda [
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
    suitesparse
    metis
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!enableStatic))
  ]
  ++ lib.optionals enableCuda [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ];

  # The Basel BUILD file conflicts with the cmake build directory on
  # case-insensitive filesystems, eg. darwin.
  preConfigure = ''
    rm BUILD
  '';

  doCheck = runTests;

  checkTarget = "test";

  meta = {
    description = "C++ library for modeling and solving large, complicated optimization problems";
    license = lib.licenses.bsd3;
    homepage = "http://ceres-solver.org";
    maintainers = with lib.maintainers; [ giogadi ];
    platforms = lib.platforms.unix;
  };
})
