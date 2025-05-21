{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2025-02-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "88b22735dbdbc4d6236ed872ef21ea1b4d2fc492";
    hash = "sha256-ouwtL8vfc1LFMjfIZQ4F/ZOBW4y3VU9zovkXug0fgZY=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
