{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "cap32";
  version = "4.5.4";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-cap32";
    rev = "8e13eb69b46ad231f181391e5f7a775a635b3a63";
    hash = "sha256-GTHnjLktb7ks9ZiuIQ0X89P5bpach/lfDsPUXgDejSA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Caprice32 libretro port (Amstrad CPC emulator)";
    homepage = "https://github.com/libretro/libretro-cap32";
    license = lib.licenses.gpl2Only;
  };
}
