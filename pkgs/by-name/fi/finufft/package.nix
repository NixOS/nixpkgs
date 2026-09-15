{
  lib,
  stdenv,
  config,
  fetchFromGitHub,
  fetchurl,
  applyPatches,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # buildInputs
  fftw,
  fftwFloat,
  llvmPackages,
  cudaPackages,

  # passthru
  nix-update-script,

  cudaSupport ? config.cudaSupport,
}:

let
  cpmSourceCache = applyPatches (finalAttrs: {
    name = "cpm-cmake";
    # grep for CPM_DOWNLOAD_VERSION in CMakeLists.txt
    version = "0.42.0";
    src = fetchurl {
      url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v${finalAttrs.version}/CPM.cmake";
      hash = "sha256-ICC0/ELbpEgXmD4GNC5oLs/D0vSEpYHxHMVzH75Nzoo=";
    };
    # CPM.cmake is a single file, not an archive, so unpackPhase just copies it.
    unpackPhase = ''
      cp $src CPM.cmake
    '';
    # Restructure into the layout CPM_SOURCE_CACHE expects:
    #   <store-path>/cpm/CPM_<version>.cmake
    postPatch = ''
      mkdir -p cpm
      mv CPM.cmake cpm/CPM_${finalAttrs.version}.cmake
    '';
  });

  # CPM fetches a cmake find module for FFTW (provides FindFFTW.cmake).
  # Pinned to the commit that upstream GIT_TAG "master" resolves to.
  findfftwSrc = fetchFromGitHub {
    owner = "egpbos";
    repo = "findFFTW";
    rev = "d449ea0bcbf94a4a1c3dbb2108aa57609a4967ff";
    hash = "sha256-JM3DL43b3dlcazEW2bmJUH+XrIDbE54xwD5fRqnntUI=";
  };

  # grep for XSIMD_VERSION in CMakeLists.txt
  xsimdSrc = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = "6842624fc8adafd7168a999e7150b384411da448";
    hash = "sha256-M6b2RDptZW5JwlVYNI4GEL6UI2Q+4sdhYBF/wP5wxeQ=";
  };

  # CCCL version pinned by finufft
  ccclSrc = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cccl";
    tag = "v3.0.2";
    hash = "sha256-sC9TpvhhFJRmZv25/l5L8jKq/wlAKLxf4C6O/a1xw/M=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "finufft";
  version = "2.5.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "flatironinstitute";
    repo = "finufft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sOApnIqxgdbBqQ6SZQk8afTvgq3/XHG/EK5WHYkwd9U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    fftw
    fftwFloat
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart # cuda_runtime.h, libcuda stub
    cudaPackages.libcufft # cufft.h
    cudaPackages.cccl # cufft.h
  ];

  env = lib.optionalAttrs cudaSupport {
    NVCC_THREADS = 2;
  };

  cmakeFlags = [
    (lib.cmakeFeature "CPM_SOURCE_CACHE" cpmSourceCache.outPath)
    (lib.cmakeFeature "CPM_findfftw_SOURCE" findfftwSrc.outPath)
    (lib.cmakeFeature "CPM_xsimd_SOURCE" xsimdSrc.outPath)

    # Build a shared library instead of the default static
    (lib.cmakeBool "FINUFFT_STATIC_LINKING" false)

    # Avoid -march=native for reproducibility
    (lib.cmakeFeature "FINUFFT_ARCH_FLAGS" "")

    (lib.cmakeBool "FINUFFT_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeBool "FINUFFT_USE_CUDA" true)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
    (lib.cmakeFeature "CPM_CCCL_SOURCE" ccclSrc.outPath)
  ];

  # GPU tests require a physical GPU, which is not available in the sandbox.
  doCheck = !cudaSupport;

  passthru = {
    gpuCheck = finalAttrs.finalPackage.overrideAttrs {
      requiredSystemFeatures = [ "cuda" ];
      doCheck = true;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Non-uniform fast Fourier transform library of types 1, 2, 3 in dimensions 1, 2, 3 on the CPU or GPU";
    homepage = "https://finufft.readthedocs.io/en/latest/index.html";
    downloadPage = "https://github.com/flatironinstitute/finufft";
    changelog = "https://github.com/flatironinstitute/finufft/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
})
