{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "77f2567d718b8973d02caa2daa8dce4953faf811";
    hash = "sha256-8iYMgRVI1sdU7GBK1lj27Ym5DY0AkUr4rpL+4i93Xm0=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
