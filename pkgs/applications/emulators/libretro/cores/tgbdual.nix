{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "tgbdual";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "tgbdual-libretro";
    rev = "12540f0b2d3783259a0dce34ac8aa7a86beeaa11";
    hash = "sha256-l+WiFC5GxbdY9ulmtdqd2iKU7qKoVWqcf4YR/waSVhQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of TGBDual to libretro";
    homepage = "https://github.com/libretro/tgbdual-libretro";
    license = lib.licenses.gpl2Only;
  };
}
