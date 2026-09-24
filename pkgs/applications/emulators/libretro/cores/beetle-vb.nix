{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-vb";
  version = "0-unstable-2026-07-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-vb-libretro";
    rev = "3f53a40bf8aa18777514fd4b220960427e312a3f";
    hash = "sha256-mIgLMgJnoGmlWSS6Z4x5GfJGV5fZxqFtLT5BdI+rgaI=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's VirtualBoy core to libretro";
    homepage = "https://github.com/libretro/beetle-vb-libretro";
    license = lib.licenses.gpl2Only;
  };
}
