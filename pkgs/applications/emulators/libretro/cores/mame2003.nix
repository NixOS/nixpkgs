{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003";
  version = "0-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-libretro";
    rev = "299789ce642b34c2679cfd89d7ecf06b09851bc1";
    hash = "sha256-FX+onEaaQUdcjAvgsrdW0m408oCSXJEJHQncrN2Uk/Y=";
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
