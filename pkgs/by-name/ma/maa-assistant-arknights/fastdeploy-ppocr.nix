{
  stdenv,
  config,
  lib,
  fetchFromGitHub,
  cmake,
  eigen,
  onnxruntime,
  opencv,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}@inputs:

let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "fastdeploy-ppocr";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "MaaXYZ";
    repo = "FastDeploy";
    # MAA pins its MaaDeps release here:
    # https://github.com/MaaAssistantArknights/MaaAssistantArknights/blob/v6.22.0/tools/maadeps-download.py#L13
    # Match the FastDeploy REF from that MaaDeps release:
    # https://github.com/MaaAssistantArknights/MaaDeps/blob/v2.15.1/vcpkg-overlay/ports/maa-fastdeploy/portfile.cmake#L4
    rev = "e11935e4595360e7038573db1a7ab08dd0e096ec";
    hash = "sha256-7g0T5TZ2M2I12nIq9Cytbi8qGw60ssxAgYr2o1pAUVU=";
  };

  outputs = [
    "out"
    "cmake"
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    eigen
    onnxruntime
    opencv
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cccl # cub/cub.cuh
      libcublas # cublas_v2.h
      libcurand # curand.h
      libcusparse # cusparse.h
      libcufft # cufft.h
      cudnn # cudnn.h
      cuda_cudart
    ]
  );

  cmakeBuildType = "None";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "WITH_CUDA" cudaSupport)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "CUDA_DIRECTORY" "${lib.getDev cudaPackages.cuda_cudart}")
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ];

  # Use CMake's CUDA architecture selection.
  postPatch = ''
    substituteInPlace fastdeploy/runtime/backends/ort/ort_backend.cc \
      --replace-fail '#if defined(WITH_COREML) && __has_include(<coreml_provider_factory.h>)' '#if defined(__APPLE__) && defined(WITH_COREML) && __has_include(<coreml_provider_factory.h>)'
    substituteInPlace CMakeLists.txt \
      --replace-fail 'include(cmake/cuda.cmake)' ""
  '';

  postInstall = ''
    mkdir $cmake
    install -Dm644 ${finalAttrs.src}/cmake/Findonnxruntime.cmake $cmake/
  '';

  meta = {
    description = "MaaAssistantArknights stripped-down version of FastDeploy";
    homepage = "https://github.com/MaaXYZ/FastDeploy";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.asl20;
    broken = cudaSupport && stdenv.hostPlatform.system != "x86_64-linux";
  };
})
