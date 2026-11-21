{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  autoPatchelfHook,
  cmake,
  ninja,
  pkg-config,

  # buildInputs
  boost,
  curl,
  dlpack,
  libdrm,
  libedit,
  libjpeg_turbo,
  libogg,
  libopus,
  libuuid,
  libvorbis,
  libwebp,
  tokenizers-cpp,
  xrt,

  # runtimeDependencies
  ffmpeg_8,

  versionCheckHook,
}:

let
  # Grammar engine for constrained decoding, vendored by upstream as a git submodule
  # (`third_party/xgrammar`). Its own submodules are not needed: dlpack comes from nixpkgs.
  xgrammar-src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = "xgrammar";
    tag = "v0.2.8";
    hash = "sha256-NZt+oWDS06KxszKg7WbmOGXb6PUSjU3W59UnTCKJbPc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fastflowlm";
  version = "1.0.11";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "FastFlowLM";
    repo = "FastFlowLM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqMMPeH51hsdZnwfXnTTircsH7lgzo8ngISIRL0TK4M=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    ./use-external-tokenizers.patch
    # Upstream downloads and builds static libjpeg-turbo, libwebp, opus, ogg and vorbis at build
    # time through ExternalProject. Use the nixpkgs libraries instead.
    ./use-system-codecs.patch
  ];

  postPatch = ''
    substituteInPlace common/chat/chat_sources.cmake \
      --replace-fail \
        '"''${CMAKE_CURRENT_LIST_DIR}/../../../third_party/xgrammar"' \
        '"${xgrammar-src}"'
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    curl
    dlpack
    libdrm
    libedit
    libjpeg_turbo
    libogg
    libopus
    libuuid
    libvorbis
    libwebp
    tokenizers-cpp
    xrt.xdna
  ];

  cmakeFlags = [
    (lib.cmakeFeature "TOKENIZERS_CPP_LIB_PATH" "${lib.getLib tokenizers-cpp}/lib/libtokenizers_cpp.a")
    (lib.cmakeFeature "TOKENIZERS_CPP_INCLUDE_PATH" "${lib.getDev tokenizers-cpp}/include")
    (lib.cmakeFeature "TOKENIZERS_C_LIB_PATH" "${lib.getLib tokenizers-cpp.tokenizers-c}/lib/libtokenizers_c.a")
    (lib.cmakeFeature "FLM_VERSION" finalAttrs.version)
    # Minimum AMD NPU driver version `flm validate` checks for, as set in upstream's CMakePresets.json
    (lib.cmakeFeature "NPU_VERSION" "32.0.203.304")
    (lib.cmakeFeature "XRT_INCLUDE_DIR" "${lib.getDev xrt.xdna}/include")
    (lib.cmakeFeature "XRT_LIB_DIR" "${lib.getLib xrt.xdna}/lib")
  ];

  env.NIX_LDFLAGS = toString [
    "-L${lib.getLib tokenizers-cpp.tokenizers-c}/lib"
    "-ltokenizers_c"
  ];

  # Video inputs are decoded by dlopen-ing FFmpeg 6, 7 or 8 (libavformat.so.62 & co.)
  runtimeDependencies = [
    (lib.getLib ffmpeg_8)
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
      # Prebuilt model engines (`lib/*.so`)
      binaryNativeCode
      # Prebuilt NPU kernels (`share/flm/xclbins/*/*.xclbin`)
      binaryFirmware
    ];
  };
})
