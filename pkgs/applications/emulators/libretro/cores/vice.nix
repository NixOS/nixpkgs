{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-07-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "94cd4c7d010957109527403fff4b753f918efd3d";
    hash = "sha256-MjdaBluBmdf22F9yG8xZtCTAqhM4P5bvIcFm0Cga9FM=";
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
