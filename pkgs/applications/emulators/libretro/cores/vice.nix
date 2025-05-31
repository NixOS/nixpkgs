{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-05-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "f27798806c60f024ce25dc9b8478f12b4d1aa0b6";
    hash = "sha256-CVDdMtw/25fCR2atJjTbejrvQcmtVwkQb+Lxj8l581c=";
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
