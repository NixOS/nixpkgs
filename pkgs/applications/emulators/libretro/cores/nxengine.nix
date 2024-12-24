{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nxengine";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nxengine-libretro";
    rev = "9adc032a5f6aa913d71d22042bb72cb11cf0f4a2";
    hash = "sha256-8XjZp18lQU3xFNDjIuNsSHn7Mhba8Lze/IeRsy8/U1U=";
  };

  makefile = "Makefile";

  meta = {
    description = "NXEngine libretro port";
    homepage = "https://github.com/libretro/nxengine-libretro";
    license = lib.licenses.gpl3Only;
  };
}
