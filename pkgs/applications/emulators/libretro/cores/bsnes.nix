{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bsnes";
  version = "0-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-libretro";
    rev = "c2df3ccaeb8f40852a63a4b66a381d82d4e9b95d";
    hash = "sha256-bPW4ftbdUXsgAs/CEi5/x4iq1NKvgRmHOpMiNJ2W/Gc=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of bsnes to libretro";
    homepage = "https://github.com/libretro/bsnes-libretro";
    license = lib.licenses.gpl3Only;
  };
}
