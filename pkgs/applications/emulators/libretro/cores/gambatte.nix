{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2024-12-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "a870b6dcde66fba00cd7aab5ae4bb699e458a91b";
    hash = "sha256-yarpWSRmfqufj3sXwO1SHZ7VnPSITK/WG8u6mHil/OE=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
