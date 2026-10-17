{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "irogb";
  version = "0-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "alexsutila";
    repo = "irogb";
    rev = "7b6bb9b1f9cbf04e49eea0dc89c54635c2b54056";
    hash = "sha256-mzWWGRc/NSHTX09GXUvwCJw0oKBXWS40E65KzkgXf5c=";
  };

  # Top level makefile invokes `cmake` for each build target
  extraNativeBuildInputs = [ cmake ];

  cmakeFlags = with lib.strings; [
    (cmakeBool "BUILD_LIBRETRO" true)
    (cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  # `mkLibretroCore` defaults to `Makefile.libretro`, but this project uses
  # a regular `Makefile` at the top level
  makefile = "Makefile";

  # The `libretro` target is generated in its own separate CMake binary dir
  # while `mkLibretroCore` expects it at the current working dir
  postBuild = "cd src/frontend/libretro";

  meta = {
    description = "A libretro port of the IroGB Game Boy Color emulator";
    homepage = "https://kaze.moe/TismForge/IroGB";
    license = lib.licenses.gpl3Only;
  };
}
