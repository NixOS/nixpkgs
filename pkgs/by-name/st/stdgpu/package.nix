{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  thrust,
  config,
  cudaPackages ? {},
  cudaSupport ? config.cudaSupport or false,
}:

let

  benchmark_src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "refs/tags/v1.8.4";
    hash = "sha256-O+1ZHaNHSkKz3PlKDyI94LqiLtjyrKxjOIi8Q236/MI=";
  };

  googletest_src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "refs/tags/v1.14.0";
    hash = "sha256-t0RchAHTJbuI5YW4uyBPykTvcjy90JW9AOPNjIhwh6U=";
  };

in

stdenv.mkDerivation (finalAttrs: {
  pname = "stdgpu";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "stotko";
    repo = "stdgpu";
    rev = finalAttrs.version;
    hash = "sha256-avjNeo5E/ENIVqpe+VxvH6QmbA3OVJ7TPjLUSt1qWkY=";
  };

  # prefetch google/benchmark and google/googletest
  postPatch = lib.optionalString finalAttrs.doCheck ''
    substituteInPlace benchmarks/CMakeLists.txt \
      --replace-fail \
        "URL https://github.com/google/benchmark/archive/${benchmark_src.rev}.zip" \
        "SOURCE_DIR ${benchmark_src}"

    substituteInPlace tests/CMakeLists.txt \
      --replace-fail \
        "URL https://github.com/google/googletest/archive/${googletest_src.rev}.zip" \
        "SOURCE_DIR ${googletest_src}"
  '';

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cccl.dev # thrust
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "STDGPU_BUILD_TESTS" finalAttrs.doCheck)
    (lib.cmakeBool "STDGPU_BUILD_BENCHMARKS" finalAttrs.doCheck)
    (lib.cmakeBool "STDGPU_BACKEND_OPENMP" true)
    (lib.cmakeBool "STDGPU_BACKEND_HIP" false) # TODO
    (lib.cmakeBool "STDGPU_BACKEND_CUDA" cudaSupport)
  ] ++ lib.optionals cudaSupport [
    # otherwise determined at build time in ./cmake/cuda/compute_capability.cpp
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" (
      lib.concatStringsSep ";" (with cudaPackages.flags; map dropDot cudaCapabilities)
    ))
    (lib.cmakeFeature "STDGPU_CUDA_COMPUTE_CAPABILITIES" (
      lib.concatStringsSep ";" (with cudaPackages.flags; map dropDot cudaCapabilities)
    ))
  ];

  # requires a CUDA device
  # also https://github.com/stotko/stdgpu/pull/292 is required to build tests with cuda12, it cannot be cherry-picked
  doCheck = false;

  meta = {
    description = "Efficient STL-like Data Structures on the GPU";
    homepage = "https://github.com/stotko/stdgpu";
    changelog = "https://github.com/stotko/stdgpu/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge pbsds ];
    mainProgram = "stdgpu";
    platforms = lib.platforms.all;
    broken = !cudaSupport; # cpu-mode requires nvcc to be present
  };
})
