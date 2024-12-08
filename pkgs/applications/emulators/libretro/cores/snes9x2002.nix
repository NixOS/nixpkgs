{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x2002";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2002";
    rev = "a0709ec7dcd6de2fbebb43106bd757b649e3b7cf";
    hash = "sha256-rrMPhXIsQ48fVvjgZgC3xeqm9k9kwe43oZNzs2d/h1Q=";
  };

  makefile = "Makefile";

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    homepage = "https://github.com/libretro/snes9x2002";
    license = lib.licenses.unfreeRedistributable;
  };
}
