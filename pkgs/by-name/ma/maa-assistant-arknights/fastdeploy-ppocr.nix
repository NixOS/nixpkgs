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
  version = "0-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "MaaXYZ";
    repo = "FastDeploy";
    # MAA pins its MaaDeps release here:
    # https://github.com/MaaAssistantArknights/MaaAssistantArknights/blob/v6.20.0/tools/maadeps-download.py#L13
    # Match the FastDeploy REF from that MaaDeps release:
    # https://github.com/MaaAssistantArknights/MaaDeps/blob/v2.14.1/vcpkg-overlay/ports/maa-fastdeploy/portfile.cmake#L4
    rev = "e962983da6daba7d0c12f6bf5f8ff7173be70982";
    hash = "sha256-T20WhXE1toEgeXbMlQn9EnLXoz5vepUca4p7C2tQK44=";
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

  # Export installed headers and use CMake's CUDA architecture selection.
  postPatch = ''
    substituteInPlace fastdeploy/runtime/backends/ort/ort_backend.cc \
      --replace-fail '#if defined(WITH_COREML) && __has_include(<coreml_provider_factory.h>)' '#if defined(__APPLE__) && defined(WITH_COREML) && __has_include(<coreml_provider_factory.h>)'
    # libc++ also rejects these std:: trait specializations on Darwin.
    substituteInPlace fastdeploy/core/float16.h \
      --replace-fail '#if defined(__linux__) && !defined(__ANDROID__) && defined(_LIBCPP_VERSION)' '#if defined(_LIBCPP_VERSION)'
    substituteInPlace CMakeLists.txt \
      --replace-fail '$<INSTALL_INTERFACE:''${CMAKE_INSTALL_INCLUDE}>' '$<INSTALL_INTERFACE:include>' \
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
