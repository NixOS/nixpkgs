{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-saturn";
  version = "0-unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-saturn-libretro";
    rev = "1382b85dcad2e98ef9a67426a775ba548eaf0c68";
    hash = "sha256-Ps3GduOqKZYP9gLD7TkSM2EzbuuEsIFCiF2hmgn9D84=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's Saturn core to libretro";
    homepage = "https://github.com/libretro/beetle-saturn-libretro";
    license = lib.licenses.gpl2Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
