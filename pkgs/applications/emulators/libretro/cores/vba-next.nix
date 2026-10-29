{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2026-05-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "f04b19879d929730d199649c5c40b75b1f15b549";
    hash = "sha256-Mv+vg0NyX1F7u8cRDpwduD+UZfCHKlcSUmB3bQGjCn8=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
