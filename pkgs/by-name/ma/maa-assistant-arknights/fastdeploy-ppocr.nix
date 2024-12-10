{
  stdenv,
  config,
  pkgs,
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
  cudaCapabilities = cudaPackages.cudaFlags.cudaCapabilities;
  # E.g. [ "80" "86" "90" ]
  cudaArchitectures = (builtins.map cudaPackages.cudaFlags.dropDot cudaCapabilities);
  cudaArchitecturesString = lib.strings.concatStringsSep ";" cudaArchitectures;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "fastdeploy-ppocr";
  version = "0-unstable-2023-10-09";

  src = fetchFromGitHub {
    owner = "Cryolitia";
    repo = "FastDeploy";
    # follows https://github.com/MaaAssistantArknights/MaaDeps/blob/master/vcpkg-overlay/ports/maa-fastdeploy/portfile.cmake#L4
    rev = "2e68908141f6950bc5d22ba84f514e893cc238ea";
    hash = "sha256-BWO4lKZhwNG6mbkC70hPgMNjabTnEV5XMo0bLV/gvQs=";
  };

  outputs = [
    "out"
    "cmake"
  ];

  nativeBuildInputs =
    [
      cmake
      eigen
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
    ];

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
      (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchitecturesString)
    ];

  postInstall = ''
    mkdir $cmake
    install -Dm644 ${finalAttrs.src}/cmake/Findonnxruntime.cmake $cmake/
  '';

  meta = with lib; {
    description = "MaaAssistantArknights stripped-down version of FastDeploy";
    homepage = "https://github.com/MaaAssistantArknights/FastDeploy";
    platforms = platforms.linux;
    license = licenses.asl20;
    broken = cudaSupport && stdenv.hostPlatform.system != "x86_64-linux";
  };
})
