{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-07-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "e9f8ac034ddef3025f0567768f7af8219f7cfdb8";
    hash = "sha256-Rut9NyBF0yPFDYtFKzvSESaZL6CFhfcw6OFIHMeuzHk=";
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
