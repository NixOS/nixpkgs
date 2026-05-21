{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pcfx";
  version = "0-unstable-2026-04-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pcfx-libretro";
    rev = "650c30ea2203636a1716675854d11c608ed6eacc";
    hash = "sha256-xB3O7N23bS2IAaWuvxIXfVodua8s1dcbZ2XAB0Lt6gc=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PCFX core to libretro";
    homepage = "https://github.com/libretro/beetle-pcfx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
