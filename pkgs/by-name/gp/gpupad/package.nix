{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  glslang,
  imath,
  ktx-tools,
  openimageio,
  qt6Packages,
  spdlog,
  spirv-cross,
  vulkan-memory-allocator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpupad";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "gpupad";
    tag = finalAttrs.version;
    hash = "sha256-B83XHRJD55rOZ/1xOmUjz5oY7b1l4GWN4HSrGoPcN8w=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    glslang
    imath # needed for openimageio
    ktx-tools
    openimageio
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
    qt6Packages.qtmultimedia
    spdlog
    spirv-cross
    vulkan-memory-allocator
  ];

  meta = {
    description = "Flexible GLSL and HLSL shader editor and IDE";
    homepage = "https://github.com/houmain/gpupad";
    changelog = "https://github.com/houmain/gpupad/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "gpupad";
    platforms = lib.platforms.linux;
  };
})
