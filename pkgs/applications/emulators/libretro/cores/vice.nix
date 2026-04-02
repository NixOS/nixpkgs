{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-03-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "8818c3a39146b9a26df23a1e4880b4420f93a255";
    hash = "sha256-Nw+F2hn97F1rKB2UOh/MMNrqmNj87XzRPgEptYoTe7o=";
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
