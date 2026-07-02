{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-05-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "bc82e8281ddbbd487875866f5db27cdb9838d319";
    hash = "sha256-laAXE4U5ROKe2QnYbUrvJ4xRPv1hzllDZ8ei01IwqKA=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
