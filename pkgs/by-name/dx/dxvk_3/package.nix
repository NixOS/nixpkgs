{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsBuildHost,
  glslang,
  meson,
  ninja,
  pkg-config,
  windows,
  spirv-headers,
  vulkan-headers,
  SDL2,
  sdl3,
  glfw,
  gitUpdater,
  sdl2Support ? (!stdenv.hostPlatform.isWindows),
  sdl3Support ? (!stdenv.hostPlatform.isWindows),
  glfwSupport ? (!stdenv.hostPlatform.isWindows),
}:

assert stdenv.hostPlatform.isWindows -> !glfwSupport && !sdl2Support && !sdl3Support;

let
  inherit (stdenv) hostPlatform;

  libPrefix = lib.optionalString (!hostPlatform.isWindows) "lib";
  soVersion =
    version:
    if hostPlatform.isDarwin then
      ".${version}${hostPlatform.extensions.sharedLibrary}"
    else if hostPlatform.isWindows then
      hostPlatform.extensions.sharedLibrary
    else
      "${hostPlatform.extensions.sharedLibrary}.${version}";

  libglfw = "${libPrefix}glfw${soVersion "3"}";
  libSDL2 = "${libPrefix}SDL2${lib.optionalString (!hostPlatform.isWindows) "-2.0"}${soVersion "0"}";
  libSDL3 = "${libPrefix}SDL3${soVersion "0"}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dxvk";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "doitsujin";
    repo = "dxvk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a9BWTdL1ZSA0Rsf2+N/udDPgSEEEU4idWBzXu8C0pY4=";
    fetchSubmodules = true; # Needed for the DirectX headers, libdisplay-info, and dxbc-spirv
  };

  postPatch = ''
    substituteInPlace subprojects/libdisplay-info/tool/gen-search-table.py \
      --replace-fail "/usr/bin/env python3" "${lib.getBin pkgsBuildHost.python3}/bin/python3"
  ''
  + lib.optionalString glfwSupport ''
    substituteInPlace src/wsi/glfw/wsi_platform_glfw.cpp \
      --replace-fail '${libglfw}' '${lib.getLib glfw}/lib/${libglfw}'
  ''
  + lib.optionalString sdl2Support ''
    substituteInPlace src/wsi/sdl2/wsi_platform_sdl2.cpp \
      --replace-fail '${libSDL2}' '${lib.getLib SDL2}/lib/${libSDL2}'
  ''
  + lib.optionalString sdl3Support ''
    substituteInPlace src/wsi/sdl3/wsi_platform_sdl3.cpp \
      --replace-fail '${libSDL3}' '${lib.getLib sdl3}/lib/${libSDL3}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    glslang
    meson
    ninja
  ]
  ++ lib.optionals (glfwSupport || sdl2Support || sdl3Support) [ pkg-config ];

  buildInputs = [
    spirv-headers
    vulkan-headers
  ]
  ++ lib.optionals sdl2Support [ SDL2 ]
  ++ lib.optionals sdl3Support [ sdl3 ]
  ++ lib.optionals glfwSupport [ glfw ]
  ++ lib.optionals hostPlatform.isWindows [ windows.pthreads ];

  # Build with the Vulkan SDK in nixpkgs.
  preConfigure = ''
    rm -rf include/spirv/include include/vulkan/include
    mkdir -p include/spirv/include include/vulkan/include
  '';

  mesonFlags = lib.optionals (!hostPlatform.isWindows) [
    (lib.mesonEnable "native_glfw" glfwSupport)
    (lib.mesonEnable "native_sdl2" sdl2Support)
    (lib.mesonEnable "native_sdl3" sdl3Support)
  ];

  mesonBuildType = "release";

  doCheck = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    allowedVersions = "^3\\.";
  };

  __structuredAttrs = true;

  meta = {
    description = "Vulkan-based translation layer for Direct3D 8/9/10/11";
    homepage = "https://github.com/doitsujin/dxvk";
    changelog = "https://github.com/doitsujin/dxvk/releases";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.zlib;
    badPlatforms = lib.platforms.darwin;
    platforms = lib.platforms.windows ++ lib.platforms.unix;
    pkgConfigModules = [
      "dxvk-d3d10core"
      "dxvk-d3d11"
      "dxvk-d3d8"
      "dxvk-d3d9"
      "dxvk-dxgi"
    ];
  };
})
