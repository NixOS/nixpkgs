{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  vulkan-loader,
  glslang,
  libwebp,
  ncnn,
}:
stdenv.mkDerivation rec {
  pname = "realcugan-ncnn-vulkan";
  version = "20220728";

  src = fetchFromGitHub {
    owner = "nihui";
    repo = "realcugan-ncnn-vulkan";
    rev = version;
    hash = "sha256-P3Y1B8m1+mpFinacwnvBE2vU150jj6Q12IS6QYNRZ6A=";
  };
  sourceRoot = "${src.name}/src";

  models = fetchzip {
    url = "https://github.com/nihui/realcugan-ncnn-vulkan/releases/download/20220728/realcugan-ncnn-vulkan-20220728-ubuntu.zip";
    sha256 = "sha256-71C6taL2Zr1exG5HEXOLy1j9ZMKgkMJjTgNi2hiA7xk=";
  };

  patches = [
    ./cmakelists.patch
    ./models_path.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_NCNN" true)
    (lib.cmakeBool "USE_SYSTEM_WEBP" true)
    (lib.cmakeFeature "GLSLANG_TARGET_DIR" "${glslang}/lib/cmake")
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    vulkan-headers
    vulkan-loader
    glslang
    libwebp
    ncnn
  ];

  postPatch = ''
    substituteInPlace main.cpp --replace REPLACE_MODELS $out/share/models-se
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    cp realcugan-ncnn-vulkan $out/bin/

    cp -r ${models}/models-{nose,pro,se} $out/share
    runHook postInstall
  '';

  meta = with lib; {
    description = "Real-cugan converter ncnn version, runs fast on intel / amd / nvidia / apple-silicon GPU with vulkan";
    homepage = "https://github.com/nihui/realcugan-ncnn-vulkan";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "realcugan-ncnn-vulkan";
    platforms = platforms.all;
  };
}
