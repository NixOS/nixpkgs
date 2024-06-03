{
  lib,
  config,
  callPackage,
  stdenv,
  overrideSDK,
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
# https://github.com/NixOS/nixpkgs/issues/314160
(if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv).mkDerivation (finalAttr: {
  pname = "maa-assistant-arknights" + lib.optionalString isBeta "-beta";
  version = if isBeta then sources.beta.version else sources.stable.version;

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "MaaAssistantArknights";
    rev = "v${finalAttr.version}";
    hash = if isBeta then sources.beta.hash else sources.stable.hash;
  };

  nativeBuildInputs = [
    asio
    cmake
    fastdeploy.cmake
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs =
    [
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

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "INSTALL_FLATTEN" false)
    (lib.cmakeBool "INSTALL_PYTHON" true)
    (lib.cmakeBool "INSTALL_RESOURCE" true)
    (lib.cmakeBool "USE_MAADEPS" false)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "None")
    (lib.cmakeFeature "MAA_VERSION" "v${finalAttr.version}")
  ];

  passthru.updateScript = ./update.sh;

  postPatch = ''
    cp -v ${fastdeploy.cmake}/Findonnxruntime.cmake cmake/
  '';

  postInstall = ''
    mkdir -p $out/share/${finalAttr.pname}
    mv $out/{Python,resource} $out/share/${finalAttr.pname}
  '';

  meta = with lib; {
    description = "An Arknights assistant";
    homepage = "https://github.com/MaaAssistantArknights/MaaAssistantArknights";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Cryolitia ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
