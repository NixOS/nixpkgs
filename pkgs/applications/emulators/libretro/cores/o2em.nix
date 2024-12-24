{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "o2em";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-o2em";
    rev = "3ba4231c1dc8dcdf487428712856b790d2e4b8f3";
    hash = "sha256-HhTkFm9Jte4wDPxTcXRgCg2tCfdQvo0M3nHRhlPmz/w=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of O2EM to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.artistic1;
  };
}
