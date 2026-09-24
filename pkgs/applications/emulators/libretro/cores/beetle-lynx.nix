{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-lynx";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-lynx-libretro";
    rev = "fcdefcfb3c11d6d2e71be076a5d3df2e88ab73ed";
    hash = "sha256-yucZWgJiqlfsgd/gQSPxSdZjt+9UfJe1Jq4vMLypDhg=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's Lynx core to libretro";
    homepage = "https://github.com/libretro/beetle-lynx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
