{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "genesis-plus-gx";
  version = "0-unstable-2025-03-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "Genesis-Plus-GX";
    rev = "1024afbcd77a7bf7c87972c7c86d3a7759877fc7";
    hash = "sha256-9Y3uzWpiYIRGTFApVGdLIONpBpPaO1sRgaGj1EVI3M4=";
  };

  meta = {
    description = "Enhanced Genesis Plus libretro port";
    homepage = "https://github.com/libretro/Genesis-Plus-GX";
    license = lib.licenses.unfreeRedistributable;
  };
}
