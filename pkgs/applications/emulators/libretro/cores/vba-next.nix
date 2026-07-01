{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2026-06-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "349b57c6442af56248433c114500a460ef9bfd8c";
    hash = "sha256-46ps2P1a8pa9vcZ7Saz8Mh+w5e2lEWjIRAw5WQh1BjQ=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
