{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "neocd";
  version = "0-unstable-2026-08-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "neocd_libretro";
    rev = "3118c6901787e863e80e79170d02d47657b3b0ab";
    hash = "sha256-PGGQexuQDNYgfVghNxR9pd8FEauimm6rxCSn2ylvY18=";
  };

  makefile = "Makefile";

  meta = {
    description = "NeoCD libretro port";
    homepage = "https://github.com/libretro/neocd_libretro";
    license = lib.licenses.lgpl3Only;
  };
}
