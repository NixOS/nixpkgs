{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox";
  version = "0-unstable-2026-09-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dosbox-libretro";
    rev = "988aa330d10b1423873ebfd8dcb6106df2538c44";
    hash = "sha256-yRipBvCzDyceBI35iHFMZPpl7md5fImRAQ8Azr7z9Rs=";
  };

  env.CXXFLAGS = "-std=gnu++11";

  meta = {
    description = "Port of DOSBox to libretro";
    homepage = "https://github.com/libretro/dosbox-libretro";
    license = lib.licenses.gpl2Only;
  };
}
