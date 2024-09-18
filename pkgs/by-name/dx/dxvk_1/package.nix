{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  glslang,
  meson,
  ninja,
  windows,
  enableMoltenVKCompat ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dxvk";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "doitsujin";
    repo = "dxvk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T93ZylxzJGprrP+j6axZwl2d3hJowMCUOKNjIyNzkmE=";
  };

  # These patches are required when using DXVK with Wine on Darwin.
  patches =
    [
      # Fixes errors building with GCC 13.
      (fetchpatch {
        url = "https://github.com/doitsujin/dxvk/commit/1a5afc77b1859e6c7e31b55e11ece899e3b5295a.patch";
        hash = "sha256-tTAsQOMAazgH/6laLNTuG2lki257VUR9EBivnD4vCuY=";
      })
    ]
    ++ lib.optionals enableMoltenVKCompat [
      # Patch DXVK to work with MoltenVK even though it doesn’t support some required features.
      # Some games work poorly (particularly Unreal Engine 4 games), but others work pretty well.
      ./darwin-dxvk-compat.patch
      # Use synchronization primitives from the C++ standard library to avoid deadlocks on Darwin.
      # See: https://www.reddit.com/r/macgaming/comments/t8liua/comment/hzsuce9/
      ./darwin-thread-primitives.patch
    ];

  strictDeps = true;

  nativeBuildInputs = [
    glslang
    meson
    ninja
  ];
  buildInputs = [ windows.pthreads ];

  mesonBuildType = "release";

  __structuredAttrs = true;

  meta = {
    description = "Vulkan-based translation layer for Direct3D 9/10/11";
    homepage = "https://github.com/doitsujin/dxvk";
    changelog = "https://github.com/doitsujin/dxvk/releases";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.zlib;
    platforms = lib.platforms.windows;
  };
})
