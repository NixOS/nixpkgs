{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  vulkan-loader,
  glslang,
  opencv,
  protobuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncnn";
  version = "20250916";

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "ncnn";
    tag = finalAttrs.version;
    hash = "sha256-CpLhEuUcjkPpEnSxEZJFFgamgj+9lYL915bUWO48odA=";
  };

  patches = [ ./cmakelists.patch ];

  cmakeFlags = [
    "-DNCNN_CMAKE_VERBOSE=1" # Only for debugging the build
    "-DNCNN_SHARED_LIB=1"
    "-DNCNN_ENABLE_LTO=1"
    "-DNCNN_VULKAN=1"
    "-DNCNN_BUILD_EXAMPLES=0"
    "-DNCNN_BUILD_TOOLS=0"
    "-DNCNN_SYSTEM_GLSLANG=1"
    "-DNCNN_PYTHON=0" # Should be an attribute
  ]
  # Requires setting `Vulkan_LIBRARY` on Darwin. Otherwise the build fails due to missing symbols.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-DVulkan_LIBRARY=-lvulkan" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    glslang
    opencv
    protobuf
  ];

  meta = {
    description = "Neural network inference framework";
    homepage = "https://github.com/Tencent/ncnn";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tilcreator ];
    platforms = lib.platforms.all;
  };
})
