{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fuse";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fuse-libretro";
    rev = "bce196fb774835fe65b3e5b821887a4ccf657167";
    hash = "sha256-N66LaveZ4P66LRYpP1KwkLKT1dvG/s7JPfDyRraVkc8=";
  };

  meta = {
    description = "Port of the Fuse Unix Spectrum Emulator to libretro";
    homepage = "https://github.com/libretro/fuse-libretro";
    license = lib.licenses.gpl3Only;
  };
}
