{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "tgbdual";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "tgbdual-libretro";
    rev = "bf816b096f1dca55ea805337d7c9e78d6b98d839";
    hash = "sha256-HpvgFN37lPZpJqwUdM8qFSGcqUkYsqSCKCLMFHD6ggM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of TGBDual to libretro";
    homepage = "https://github.com/libretro/tgbdual-libretro";
    license = lib.licenses.gpl2Only;
  };
}
