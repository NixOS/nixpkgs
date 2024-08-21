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
  version = "0-unstable-2023-10-09";

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "FastDeploy";
    # follows but not fully follows https://github.com/MaaAssistantArknights/MaaDeps/blob/master/vcpkg-overlay/ports/maa-fastdeploy/portfile.cmake#L4
    rev = "0db6000aaac250824266ac37451f43ce272d80a3";
    hash = "sha256-5TItnPDc5WShpZAgBYeqgI9KKkk3qw/M8HPMlq/H4BM=";
  };

  outputs = [
    "out"
    "cmake"
  ];

  nativeBuildInputs = [
    cmake
    eigen
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs =
    [
      onnxruntime
      opencv
    ]
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cccl # cub/cub.cuh
        libcublas # cublas_v2.h
        libcurand # curand.h
        libcusparse # cusparse.h
        libcufft # cufft.h
        cudnn # cudnn.h
        cuda_cudart
      ]
    );

  cmakeFlags =
    [
      (lib.cmakeFeature "CMAKE_BUILD_TYPE" "None")
      (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
    ];

  postInstall = ''
    mkdir $cmake
    install -Dm644 ${finalAttrs.src}/cmake/Findonnxruntime.cmake $cmake/
  '';

  meta = with lib; {
    description = "MaaAssistantArknights stripped-down version of FastDeploy";
    homepage = "https://github.com/MaaAssistantArknights/FastDeploy";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    broken = cudaSupport && stdenv.hostPlatform.system != "x86_64-linux";
  };
})
