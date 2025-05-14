{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "5f094cfb57d1f656027a9d26bda681b6ecc46419";
    hash = "sha256-XqWAh3e2Q/i7c8nxqDP+sJHGdYWCyqdk2pwJ+JPsdVk=";
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
