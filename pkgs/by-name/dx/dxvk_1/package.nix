{ lib
, stdenv
, fetchFromGitHub
, glslang
, meson
, ninja
, windows
, pkgsBuildHost
, enableMoltenVKCompat ? false
}:

stdenv.mkDerivation (finalAttrs:  {
  pname = "dxvk";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "doitsujin";
    repo = "dxvk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T93ZylxzJGprrP+j6axZwl2d3hJowMCUOKNjIyNzkmE=";
  };

  # These patches are required when using DXVK with Wine on Darwin.
  patches = lib.optionals enableMoltenVKCompat [
    # Patch DXVK to work with MoltenVK even though it doesn’t support some required features.
    # Some games work poorly (particularly Unreal Engine 4 games), but others work pretty well.
    ./darwin-dxvk-compat.patch
    # Use synchronization primitives from the C++ standard library to avoid deadlocks on Darwin.
    # See: https://www.reddit.com/r/macgaming/comments/t8liua/comment/hzsuce9/
    ./darwin-thread-primitives.patch
  ];

  nativeBuildInputs = [ glslang meson ninja ];
  buildInputs = [ windows.pthreads ];

  mesonFlags = [
    "--buildtype" "release"
    "--prefix" "${placeholder "out"}"
  ];

  meta = {
    description = "A Vulkan-based translation layer for Direct3D 9/10/11";
    homepage = "https://github.com/doitsujin/dxvk";
    changelog = "https://github.com/doitsujin/dxvk/releases";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.zlib;
    platforms = lib.platforms.windows;
  };
})
