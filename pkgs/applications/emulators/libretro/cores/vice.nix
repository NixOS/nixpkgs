{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-07-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "d545628dfacc90c4124381f254c693ec92f6cb7e";
    hash = "sha256-l3FLtD+MBP8hCikHlbNsoYt+8ASb2zW+K52/nRIpfCs=";
  };

  makefile = "Makefile";

  env = {
    EMUTYPE = "${type}";
  };

  meta = {
    description = "Port of vice to libretro";
    homepage = "https://github.com/libretro/vice-libretro";
    license = lib.licenses.gpl2;
  };
}
