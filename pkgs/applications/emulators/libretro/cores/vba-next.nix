{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2026-06-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "91de6188c2544ecb13c7bc05e4d9c361d21a49ad";
    hash = "sha256-gC5SAw7wHlMxvFFXOSFB5abInAme23140eAm5uyOlNg=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
