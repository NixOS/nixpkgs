{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-08-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "c8c242db75a559246d6d51017e6dd4ecd75d6a9f";
    hash = "sha256-InKQfyd2iBHUAmyb1GVi+g6nqsKstElvUadWt4eBrcI=";
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
