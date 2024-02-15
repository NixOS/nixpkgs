{ lib
, stdenv
, fetchFromGitHub
, pkgsBuildHost
, glslang
, meson
, ninja
, windows
, spirv-headers
, vulkan-headers
, SDL2
, glfw
, gitUpdater
, sdl2Support ? true
, glfwSupport ? false
}:

# SDL2 and GLFW support are mutually exclusive.
assert !sdl2Support || !glfwSupport;

let
  isWindows = stdenv.hostPlatform.uname.system == "Windows";
in
stdenv.mkDerivation (finalAttrs:  {
  pname = "dxvk";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "doitsujin";
    repo = "dxvk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RU+B0XfphD5HHW/vSzqHLUaGS3E31d5sOLp3lMmrCB8=";
    fetchSubmodules = true; # Needed for the DirectX headers and libdisplay-info
  };

  postPatch = ''
    substituteInPlace "subprojects/libdisplay-info/tool/gen-search-table.py" \
      --replace "/usr/bin/env python3" "${lib.getBin pkgsBuildHost.python3}/bin/python3"
  '';

  nativeBuildInputs = [ glslang meson ninja ];
  buildInputs = [ spirv-headers vulkan-headers ]
    ++ lib.optionals (!isWindows && sdl2Support) [ SDL2 ]
    ++ lib.optionals (!isWindows && glfwSupport) [ glfw ]
    ++ lib.optionals isWindows [ windows.pthreads ];

  # Build with the Vulkan SDK in nixpkgs.
  preConfigure = ''
    rm -rf include/spirv/include include/vulkan/include
    mkdir -p include/spirv/include include/vulkan/include
  '';

  mesonFlags = [
    "--buildtype" "release"
    "--prefix" "${placeholder "out"}"
  ] ++ lib.optional glfwSupport "-Ddxvk_native_wsi=glfw";

  doCheck = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "A Vulkan-based translation layer for Direct3D 9/10/11";
    homepage = "https://github.com/doitsujin/dxvk";
    changelog = "https://github.com/doitsujin/dxvk/releases";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.zlib;
    platforms = lib.platforms.windows ++ lib.platforms.linux;
  };
})
