{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supergrafx";
  version = "0-unstable-2026-10-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-supergrafx-libretro";
    rev = "9c11dcd213a79d57d2c86313971631af801f2cdc";
    hash = "sha256-m4G8XAyae9kBz5Zf3NWhQBJy4n7nHdiEH0BjaqNt8pM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's SuperGrafx core to libretro";
    homepage = "https://github.com/libretro/beetle-supergrafx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
