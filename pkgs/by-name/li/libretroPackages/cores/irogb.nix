{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "irogb";
  version = "0-unstable-2026-10-29";

  src = fetchFromGitHub {
    owner = "alexsutila";
    repo = "irogb";
    rev = "430917297bbe5d5fdcbcc29aee7e03fc5b670fd9";
    hash = "sha256-m3O3+9a3fL0CpqVhXCOnSbYQXbW+y0ICsN6y/m3I3T0=";
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
    description = "Libretro port of the IroGB Game Boy Color emulator";
    homepage = "https://kaze.moe/TismForge/IroGB";
    license = lib.licenses.gpl3Only;
  };
}
