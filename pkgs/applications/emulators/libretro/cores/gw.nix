{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gw";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gw-libretro";
    rev = "435e5cfd4bf6aea03a84259e9b8dba3daf3ff5bd";
    hash = "sha256-csaOqrZMSk9xZUlGAKgypV38q9XE7K6hLLdBC10g9Ao=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Game and Watch to libretro";
    homepage = "https://github.com/libretro/gw-libretro";
    license = lib.licenses.zlib;
  };
}
