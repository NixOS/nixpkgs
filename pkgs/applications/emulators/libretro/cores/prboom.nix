{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prboom";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-prboom";
    rev = "535b8315e42f22887f36715de3ffc72b34d2dad5";
    hash = "sha256-aAlGfOcjVB1nOnA+QjVB2VfPX0Ry71QENfxIFdf/L18=";
  };

  makefile = "Makefile";

  meta = {
    description = "Prboom libretro port";
    homepage = "https://github.com/libretro/libretro-prboom";
    license = lib.licenses.gpl2Only;
  };
}
