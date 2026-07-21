{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-06-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "7946cfa0d3775e958616d4d107de867a4616ae6c";
    hash = "sha256-tsOACtp58eXar5y3unuz46sVkQ/ZTSF9go9G56iNyxo=";
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
