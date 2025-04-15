{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-03-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "9b201cdd612bfb12c8d86696656b79eaf25924ab";
    hash = "sha256-YilHxQLZC8MVnZ9EekCqtU8rgOB/0FH2vKFdn6l3i5Q=";
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
