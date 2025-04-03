{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-02-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "50cd8c29c8abab29e8d55e8fab8e131fadfbe98c";
    hash = "sha256-Vj7clLLkYyesnP9lL0Z4sy2kvxTsatKzuW6XBg21Jrw=";
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
