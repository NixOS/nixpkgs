{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce-fast";
  version = "0-unstable-2026-03-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-fast-libretro";
    rev = "0fa44d2500ebc9bf96d2808209be27a69006df79";
    hash = "sha256-NBL506+aaLRQh9XawvvynNRunWDPqxrt7ngy6FCmiIQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine fast core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-fast-libretro";
    license = lib.licenses.gpl2Only;
  };
}
