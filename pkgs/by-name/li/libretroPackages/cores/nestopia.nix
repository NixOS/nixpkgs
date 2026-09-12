{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "0a46d231849ecfa3d777b6bf9107d57ce82452cb";
    hash = "sha256-vd76pNalU7AqRTvCs/usWFwY6fYPTppJ1PkSapzbcl4=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
