{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "neocd";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "neocd_libretro";
    rev = "5eca2c8fd567b5261251c65ecafa8cf5b179d1d2";
    hash = "sha256-72tmPCb7AXsamaQsMAPiYpgDR8DER2GTz4hcbN8wy7g=";
  };

  makefile = "Makefile";

  meta = {
    description = "NeoCD libretro port";
    homepage = "https://github.com/libretro/neocd_libretro";
    license = lib.licenses.lgpl3Only;
  };
}
