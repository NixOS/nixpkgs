{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-01-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "5afa33f347306f168ff0b4c54a7825895dd07b50";
    hash = "sha256-D0DSKgqZV8EluRry2qSm7qnWnvwwDWz91G66W4nF2Kk=";
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
