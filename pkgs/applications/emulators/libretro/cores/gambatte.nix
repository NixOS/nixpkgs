{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-07-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "dfc165599f3f1068c40a0b7ad6fe5f161283d483";
    hash = "sha256-a7GXw0B/ekIcNl08s1DpuRQZyxm4tYGWzNVVBTjXeOk=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
