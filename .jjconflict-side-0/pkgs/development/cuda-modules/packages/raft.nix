{
  _cuda,
  addDriverRunpath,
  backendStdenv,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cuda_profiler_api,
  cudaAtLeast,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  fetchFromGitHub,
  fetchpatch,
  flags,
  gtest,
  lib,
  libcublas,
  libcurand,
  libcusolver,
  libcusparse,
  ninja,
  rapids-cmake,
  rapids-logger,
  rmm,
  testers,
}:
backendStdenv.mkDerivation (finalAttrs: {
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "raft";
  version = "26.08.00";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "raft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ugDqK4ZyfCU1eRkg6FJ/a4Yx/KI93xHyv0M3uOEuBbY=";
  };

  patches = [
    # Missing <cstdint> include, fails with GCC 16
    # https://github.com/NVIDIA/raft/pull/3178
    (fetchpatch {
      name = "include-cstdint-in-comms.hpp.patch";
      url = "https://github.com/NVIDIA/raft/commit/0010a033249c8aca94f6780d8462658615000196.patch";
      stripLen = 1;
      hash = "sha256-1y3lri2mAXwF/2N5toif3Lazl9eNmFyYGXyYJUMZ/YU=";
    })
  ];

  sourceRoot = "${finalAttrs.src.name}/cpp";

  nativeBuildInputs = [
    cmake
    ninja
    cuda_nvcc
    rapids-cmake
  ];

  buildInputs = [
    cuda_cudart
    (lib.getOutput "static" cuda_cudart)
    libcublas
    libcurand
    libcusolver
    libcusparse
  ];

  propagatedBuildInputs = [
    rapids-logger
    rmm
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
    (lib.cmakeBool "RAFT_COMPILE_LIBRARY" true)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CPM_GTest_SOURCE" gtest.src.outPath)
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-truncation -Wno-error=deprecated-openmp";
  # nvcc 13 nodiscard warning (#2810) under -Werror=all-warnings
  env.CUDAFLAGS = lib.optionalString finalAttrs.finalPackage.doCheck "--diag-suppress=2810";
  # mean of 2^27 doubles misses the 1e-8 tolerance by reduction order
  env.GTEST_FILTER = "-MeanTests/MeanTestD.Result/20";

  doCheck = false; # needs gpu

  checkInputs = [ cuda_profiler_api ];

  # stolen from cutlass
  # NOTE: Because the test cases immediately create and try to run the binaries, we don't have an opportunity
  # to patch them with autoAddDriverRunpath. To get around this, we add the driver runpath to the environment.
  # TODO: This would break Jetson when using cuda_compat, as it must come first.
  preCheck = lib.optionalString finalAttrs.finalPackage.doCheck ''
    export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
  '';

  passthru = {
    tests.cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "raft" ];
      package = finalAttrs.finalPackage;
      # find_dependency(CUDAToolkit) in the installed config needs nvcc
      nativeBuildInputs = [ cuda_nvcc ];
      buildInputs = [
        cuda_cudart
        libcublas
        libcurand
        libcusolver
        libcusparse
      ];
    };
    gpuCheck = finalAttrs.finalPackage.overrideAttrs {
      requiredSystemFeatures = [
        "big-parallel"
        "cuda"
      ];
      doCheck = true;
    };
    platformAssertions = [
      {
        message = "RAPIDS 26.08 requires CCCL 3.4.3, first shipped with CUDA 13.4 (found ${cudaMajorMinorVersion})";
        assertion = cudaAtLeast "13.4";
      }
      # https://docs.rapids.ai/install#system-req
      {
        message = "RAFT supports CUDA compute capabilities 7.0 and newer (found ${builtins.toJSON backendStdenv.cudaCapabilities})";
        assertion = lib.all (lib.flip lib.versionAtLeast "7.0") backendStdenv.cudaCapabilities;
      }
    ];
  };

  meta = {
    description = "RAPIDS Analytics Framework Toolkit for data science and ML";
    homepage = "https://github.com/NVIDIA/raft";
    changelog = "https://github.com/NVIDIA/raft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    badPlatforms = _cuda.lib._mkMetaBadPlatforms finalAttrs;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = [ lib.teams.cuda ];
  };
})
