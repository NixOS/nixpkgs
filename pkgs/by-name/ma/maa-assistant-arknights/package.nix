{
  lib,
  config,
  callPackage,
  stdenv,
  fetchFromGitHub,
  asio,
  cmake,
  libcpr,
  onnxruntime,
  opencv,
  isBeta ? false,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:

let
  fastdeploy = callPackage ./fastdeploy-ppocr.nix { };
  sources = lib.importJSON ./pin.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "maa-assistant-arknights" + lib.optionalString isBeta "-beta";
  version = if isBeta then sources.beta.version else sources.stable.version;

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "MaaAssistantArknights";
    rev = "v${finalAttrs.version}";
    hash = if isBeta then sources.beta.hash else sources.stable.hash;
  };

  nativeBuildInputs = [
    asio
    cmake
    fastdeploy.cmake
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    fastdeploy
    libcpr
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

  cmakeBuildType = "None";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "INSTALL_FLATTEN" false)
    (lib.cmakeBool "INSTALL_PYTHON" true)
    (lib.cmakeBool "INSTALL_RESOURCE" true)
    (lib.cmakeBool "USE_MAADEPS" false)
    (lib.cmakeFeature "MAA_VERSION" "v${finalAttrs.version}")
  ];

  passthru.updateScript = ./update.sh;

  postPatch = ''
    cp -v ${fastdeploy.cmake}/Findonnxruntime.cmake cmake/
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
