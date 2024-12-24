{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-lynx";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-lynx-libretro";
    rev = "7fead71b49e0f08be5c4d4224fea73c6174763bf";
    hash = "sha256-fYBx/bjbhRXoVIGnEg4/oMVm705ivL1os+FfVQLRSyI=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's Lynx core to libretro";
    homepage = "https://github.com/libretro/beetle-lynx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
