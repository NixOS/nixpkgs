{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-ngp";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-ngp-libretro";
    rev = "139fe34c8dfc5585d6ee1793a7902bca79d544de";
    hash = "sha256-ruWnCgMxfpPHTWQ7vgNUczmGRzNKKhoZTNlUcNgm4T8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's NeoGeo Pocket core to libretro";
    homepage = "https://github.com/libretro/beetle-ngp-libretro";
    license = lib.licenses.gpl2Only;
  };
}
