{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-ngp";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-ngp-libretro";
    rev = "0c81ce8991a47aac5d0a7d1ae53de75bc7ddf847";
    hash = "sha256-+HGzNSkM0bs8DoBCZ3FqxoqjBSwnKvK7K38341vUYco=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's NeoGeo Pocket core to libretro";
    homepage = "https://github.com/libretro/beetle-ngp-libretro";
    license = lib.licenses.gpl2Only;
  };
}
