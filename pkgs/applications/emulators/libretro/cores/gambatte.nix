{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-12-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "308255e4a3acb38a054ebb42a5e2fe5c50eebd66";
    hash = "sha256-a75F7kfrVfIVt5yvYIu+oVmpXlOdTDTs5IX1Q5NB8WU=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
