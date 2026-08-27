{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "7db129b1ecdccb38cb4d7184bcbed39beed79656";
    hash = "sha256-KvUseE8hYMv8W73gBYgzoFq5wklHHzU7B1DttBQS+yQ=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
