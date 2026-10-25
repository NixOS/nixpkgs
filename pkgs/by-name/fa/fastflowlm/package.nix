{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  cmake,
  ninja,
  pkg-config,
  boost,
  curl,
  cargo,
  ffmpeg,
  openxr-loader,
  libuuid,
  libdrm,
  fftw,
  fftwFloat,
  fftwLongDouble,
  tokenizers-cpp,
  xrt,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastflowlm";
  version = "0.9.46";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "FastFlowLM";
    repo = "FastFlowLM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Gfx0uObOnbqn2V54AeK/SLZ9arsGSJDg2tk4B3V9aw=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    ./use-external-tokenizers.patch
  ];

  # Disable symlink creation that tries to write to /usr/local/bin
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'if(NOT WIN32 AND NOT FLM_PORTABLE_BUILD AND NOT CMAKE_INSTALL_PREFIX STREQUAL "/usr" AND NOT CMAKE_INSTALL_PREFIX STREQUAL "/usr/local")' \
        'if(FALSE)'
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    cargo
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    curl
    ffmpeg
    fftw
    fftwFloat
    fftwLongDouble
    libdrm
    libuuid
    openxr-loader
    tokenizers-cpp
    # tokenizers-cpp.tokenizers-c
    xrt.xdna
  ];

  cmakeFlags = [
    (lib.cmakeFeature "TOKENIZERS_CPP_LIB_PATH" "${lib.getLib tokenizers-cpp}/lib/libtokenizers_cpp.a")
    (lib.cmakeFeature "TOKENIZERS_CPP_INCLUDE_PATH" "${lib.getDev tokenizers-cpp}/include")
    (lib.cmakeFeature "TOKENIZERS_C_LIB_PATH" "${lib.getLib tokenizers-cpp.tokenizers-c}/lib/libtokenizers_c.a")
    (lib.cmakeFeature "FLM_VERSION" finalAttrs.version)
    (lib.cmakeFeature "NPU_VERSION" finalAttrs.version)
    (lib.cmakeFeature "XRT_INCLUDE_DIR" "${lib.getDev xrt.xdna}/include")
    (lib.cmakeFeature "XRT_LIB_DIR" "${lib.getLib xrt.xdna}/lib")
  ];

  env.NIX_LDFLAGS = toString [
    "-L${lib.getLib tokenizers-cpp.tokenizers-c}/lib"
    "-ltokenizers_c"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "High-performance LLM inference engine for AMD Ryzen AI NPUs";
    homepage = "https://fastflowlm.com";
    downloadPage = "https://github.com/FastFlowLM/FastFlowLM";
    changelog = "https://github.com/FastFlowLM/FastFlowLM/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      unfree
    ];
    maintainers = with lib.maintainers; [ JohnMolotov ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "flm";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
