{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2025-03-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "6efc4b8fd4c7423ec1f5ff1913b854529135b565";
    hash = "sha256-B5GEzI/U/F0IsppdOx5znu+4LdZOxQLcGAez+oR2PCI=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
