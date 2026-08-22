{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  getopt,
  nix-update-script,

  directx-headers,
  directxmath,
  directxtex,
  glslang,
  imath,
  kissfft,
  nlohmann_json,
  openimageio,
  pipewire,
  qt6Packages,
  spdlog,
  spirv-cross,
  spirv-headers,
  spirv-reflect,
  spirv-tools,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
}:

let
  ktx-src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "KTX-Software";
    rev = "26cddc8d99386eb4120b8416956d54661fef15c5";
    hash = "sha256-j5v8e/WxgXYVKAvSoqJcevAhFH59YJJzfYSTc20pICc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gpupad";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "gpupad";
    tag = finalAttrs.version;
    hash = "sha256-MBJsE/b7/t80ts6DglVoCQOdIcnvgX4+dWdD9cMWNWY=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    getopt # needed by ktx-src/scripts/mkversion
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    glslang
    imath # needed for openimageio
    nlohmann_json
    openimageio
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
    qt6Packages.qtmultimedia
    spdlog
    spirv-headers
    spirv-tools
    vulkan-headers
    vulkan-loader
  ];

  cmakeFlags = [
    (lib.cmakeFeature "VERSION" finalAttrs.version)
    (lib.cmakeBool "GPUPAD_NLOHMANN_JSON_FIND_PACKAGE" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DIRECTX-HEADERS" "${directx-headers.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DIRECTXMATH" "${directxmath.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DIRECTXTEX" "${directxtex.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_KISSFFT" "${kissfft.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPIRV-CROSS" "${spirv-cross.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPIRV-REFLECT" "${spirv-reflect.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_VULKAN-MEMORY-ALLOCATOR" "${vulkan-memory-allocator.src
    }")
  ];

  preConfigure = ''
    cp -r ${ktx-src} ktx-src
    chmod -R +w ktx-src
    patchShebangs ktx-src/scripts/mkversion
    appendToVar cmakeFlags "-DFETCHCONTENT_SOURCE_DIR_KTXSOFTWARE=$(pwd)/ktx-src"
  '';

  # qtmultimedia's ffmpeg backend dlopens libpipewire-0.3 at runtime,
  # so it is not kept in the shrunk RPATH
  qtWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ pipewire ])
  ];

  # `gpupad` and a symlink to `gpupad` called `gpupad-headless` is installed into `$out/bin`
  # The program knows it's in headless mode if the argv0 is gpupad-headless
  # Sadly, the implementation of `wrapQtAppsHook` doesn't use --inherit-argv0 when replacing symlinks
  # This means the automatic wrapping breaks the argv0 logic, so we need to manually wrap the main `gpupad` binary only
  dontWrapQtApps = true;

  postFixup = ''
    wrapQtApp "$out/bin/gpupad"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flexible GLSL and HLSL shader editor and IDE";
    homepage = "https://github.com/houmain/gpupad";
    changelog = "https://github.com/houmain/gpupad/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "gpupad";
    platforms = lib.platforms.linux;
  };
})
