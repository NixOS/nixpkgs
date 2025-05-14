{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "d0ec7f3e209a91b903bb9d2c2397fef2bb3cca32";
    hash = "sha256-g3Eb1bMGjt+H7awUlMCtKVu223+UvyQ2VBh8aQG1yo8=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
