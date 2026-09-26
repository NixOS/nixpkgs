{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vbam";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vbam-libretro";
    rev = "115defb3a318258ab84746d45258a1aec19d0b4b";
    hash = "sha256-17Od/qXD3dy0JOi0FX46AvGGiJxN++qaXWzMfMX3q7M=";
  };

  makefile = "Makefile";
  preBuild = "cd src/libretro";

  meta = {
    description = "VBA-M libretro port";
    homepage = "https://github.com/libretro/vbam-libretro";
    license = lib.licenses.gpl2Only;
  };
}
