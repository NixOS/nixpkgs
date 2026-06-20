{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-06-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "e99e1bd9b91de67ac12c77c3679c85447c26e8c8";
    hash = "sha256-i5Bx5MstvwwKfH/Lmlj3jheQsbHP2BU8Ecpp3m5D8HA=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
