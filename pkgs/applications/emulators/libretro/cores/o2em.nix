{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "o2em";
  version = "0-unstable-2026-07-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-o2em";
    rev = "69bc3429c878929463a7d6fa7630b596dcbcb372";
    hash = "sha256-heIFcimiy2QE7Ijo6I1RGw0zPQkJSGmlAD5XLQxghU0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of O2EM to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.artistic1;
  };
}
