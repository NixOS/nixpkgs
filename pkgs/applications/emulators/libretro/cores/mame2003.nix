{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003";
  version = "0-unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-libretro";
    rev = "8565eec2e963b78f07a5a1f4b74df1271f3ece13";
    hash = "sha256-pChPUwKIOtP4nl9ReqlrgxOJ/qcO6m2SnHhx3Y+hktM=";
  };

  # Fix build with GCC 14
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003 to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
