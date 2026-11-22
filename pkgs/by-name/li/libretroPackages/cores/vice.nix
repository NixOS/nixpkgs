{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "76cde0b2cc4e52106618f2cc5d9d1112d9205c89";
    hash = "sha256-taVseLw61F/qmSj7Mpoll/h9mxf5mAcW8nCSsy47dBg=";
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
