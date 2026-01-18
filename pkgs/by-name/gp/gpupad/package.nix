{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "gpupad";
    tag = finalAttrs.version;
    hash = "sha256-Y0LNz8qHNfYhkh+ukJFi56zdaNIy5Gfvena+gSo0oOo=";
    fetchSubmodules = true;
  };

  patches = [
    # the current version of glslang no longer separates its libs into sublibs
    ./glslang-use-combined-lib.patch

    (fetchpatch {
      name = "add-missing-inline.patch";
      url = "https://github.com/houmain/gpupad/commit/52fcb3619e5e2698a8c11a97668670a5cd0531a8.patch";
      hash = "sha256-FnC5uKickZVPVr+y1Thvtk+Xi38V0AHBYGU+x64EXrA=";
    })
  ];

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
