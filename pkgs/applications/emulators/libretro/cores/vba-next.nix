{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "2c726f25da75a5600ef5791ce904befe06c4dddd";
    hash = "sha256-Elb6cOm2oO+3fNUaTXLN4kyhftoJ/oWXD571mXApybs=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
