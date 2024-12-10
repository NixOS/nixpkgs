{
  lib,
  config,
  callPackage,
  stdenv,
  fetchFromGitHub,
  asio,
  cmake,
  eigen,
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
stdenv.mkDerivation (finalAttr: {
  pname = "maa-assistant-arknights" + lib.optionalString isBeta "-beta";
  version = if isBeta then sources.beta.version else sources.stable.version;

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "MaaAssistantArknights";
    rev = "v${finalAttr.version}";
    hash = if isBeta then sources.beta.hash else sources.stable.hash;
  };

  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=maa-assistant-arknights
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'RUNTIME DESTINATION .' ' ' \
      --replace-fail 'LIBRARY DESTINATION .' ' ' \
      --replace-fail 'PUBLIC_HEADER DESTINATION .' ' '

    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_package(asio ' '# find_package(asio ' \
      --replace-fail 'asio::asio' ' '

    shopt -s globstar nullglob

    substituteInPlace src/MaaCore/**/{*.h,*.cpp,*.hpp,*.cc} \
      --replace 'onnxruntime/core/session/' ""
    substituteInPlace CMakeLists.txt \
      --replace-fail 'ONNXRuntime' 'onnxruntime'

    cp -v ${fastdeploy.cmake}/Findonnxruntime.cmake cmake/
  '';

  nativeBuildInputs =
    [
      asio
      cmake
      fastdeploy.cmake
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
    ];

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
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "None")
    (lib.cmakeBool "USE_MAADEPS" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "INSTALL_RESOURCE" true)
    (lib.cmakeBool "INSTALL_PYTHON" true)
    (lib.cmakeFeature "MAA_VERSION" "v${finalAttr.version}")
  ];

  passthru.updateScript = ./update.sh;

  postInstall = ''
    mkdir -p $out/share/${finalAttr.pname}
    mv $out/{Python,resource} $out/share/${finalAttr.pname}
  '';

  meta = with lib; {
    description = "An Arknights assistant";
    homepage = "https://github.com/MaaAssistantArknights/MaaAssistantArknights";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Cryolitia ];
    platforms = platforms.linux;
  };
})
