{
  lib,
  fetchFromGitHub,
  hexdump,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "sameboy";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "sameboy";
    rev = "51433012a871a44555492273fd22f29867d12655";
    hash = "sha256-vPT2uRGbXmJ62yig/yk485/TxEEKHJeWdNrM2c0IjKw=";
  };

  extraNativeBuildInputs = [
    which
    hexdump
  ];
  preBuild = "cd libretro";
  makefile = "Makefile";

  meta = {
    description = "SameBoy libretro port";
    homepage = "https://github.com/libretro/SameBoy";
    license = lib.licenses.mit;
  };
}
