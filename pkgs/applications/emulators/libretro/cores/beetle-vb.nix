{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-vb";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-vb-libretro";
    rev = "1275bd7bddf2166be5a10e45c26c5c2a61370658";
    hash = "sha256-3JTcAITogWP9yQ4sLZl8YlUHzu9LvWor9liQRIwf2b8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's VirtualBoy core to libretro";
    homepage = "https://github.com/libretro/beetle-vb-libretro";
    license = lib.licenses.gpl2Only;
  };
}
