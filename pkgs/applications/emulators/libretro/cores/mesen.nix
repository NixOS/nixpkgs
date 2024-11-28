{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mesen";
  version = "0-unstable-2024-06-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mesen";
    rev = "91db6be681f70b2080525c267af6132555323ea1";
    hash = "sha256-rw/bwHaeglO/DPeOCFHAWF5Y5DXVKiteO4bWZjTB4rI=";
  };

  makefile = "Makefile";
  preBuild = "cd Libretro";

  meta = {
    description = "Port of Mesen to libretro";
    homepage = "https://github.com/libretro/mesen";
    license = lib.licenses.gpl3Only;
  };
}
