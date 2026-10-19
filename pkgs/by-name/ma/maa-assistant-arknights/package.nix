{
  lib,
  config,
  callPackage,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  nlohmann_json,
  onnxruntime,
  opencv,
  zlib,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:

let
  fastdeploy = callPackage ./fastdeploy-ppocr.nix {
    inherit cudaSupport cudaPackages;
  };
  source = lib.importJSON ./pin.json;
  maaUtils = fetchFromGitHub {
    owner = "MaaXYZ";
    repo = "MaaUtils";
    inherit (source.maaUtils) rev hash;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "maa-assistant-arknights";
  version = source.version;

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "MaaAssistantArknights";
    rev = "v${finalAttrs.version}";
    hash = source.hash;
  };

  nativeBuildInputs = [
    cmake
    fastdeploy.cmake
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    fastdeploy
    boost
    nlohmann_json
    onnxruntime
    opencv
    zlib
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
    (lib.cmakeBool "INSTALL_FLATTEN" false)
    (lib.cmakeBool "INSTALL_PYTHON" true)
    (lib.cmakeBool "INSTALL_RESOURCE" true)
    (lib.cmakeBool "WITH_RPATH_LIBRARY" false)
    (lib.cmakeFeature "MAA_HASH_VERSION" "v${finalAttrs.version}")
  ];

  postUnpack = ''
    mkdir -p "$sourceRoot/src/MaaUtils"
    cp -r --no-preserve=mode ${maaUtils}/. "$sourceRoot/src/MaaUtils/"
  '';

  patches = [
    ./use-system-dependencies.patch
    ./boost-process-v1.patch
    ./missing-unordered-map-include.patch
  ];

  passthru.updateScript = ./update.sh;

  postPatch = ''
    substituteInPlace src/MaaCore/Config/OnnxSessions.cpp \
      --replace-fail '#if __has_include(<onnxruntime/coreml_provider_factory.h>)' '#if defined(__APPLE__) && __has_include(<onnxruntime/coreml_provider_factory.h>)'
    substituteInPlace src/MaaUtils/cmake/config.cmake \
      --replace-fail '-Werror;' ""
    cp ${fastdeploy.cmake}/Findonnxruntime.cmake src/MaaUtils/cmake/modules/
    substituteInPlace src/MaaUtils/MaaUtils.cmake \
      --replace-fail 'find_package(ONNXRuntime REQUIRED)' 'find_package(onnxruntime REQUIRED)'
    substituteInPlace src/MaaCore/CMakeLists.txt \
      --replace-fail 'ONNXRuntime::ONNXRuntime' 'onnxruntime::onnxruntime'
  '';

  postInstall = ''
    mkdir -p $out/share/${finalAttrs.pname}
    mv $out/{Python,resource} $out/share/${finalAttrs.pname}
  '';

  meta = {
    description = "Arknights assistant";
    homepage = "https://github.com/MaaAssistantArknights/MaaAssistantArknights";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Cryolitia ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
