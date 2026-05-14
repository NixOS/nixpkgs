{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "f56ea99799b51fb107a4d3afe2a97a1364e8d806";
    hash = "sha256-gbBurV2N6evLnZqvcxAZ2xfKMsybVeu+Nml0p0APTRE=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
