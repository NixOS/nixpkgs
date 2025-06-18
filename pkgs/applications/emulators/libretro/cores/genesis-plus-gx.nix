{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "genesis-plus-gx";
  version = "0-unstable-2025-06-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "Genesis-Plus-GX";
    rev = "def3a7c0e413ef35a7d9d4430e5c9c9a5698b4fe";
    hash = "sha256-MCLPReWzW+NsEVtt4ySplLzGKGAaNXgDtoPYJC2yY3I=";
  };

  meta = {
    description = "Enhanced Genesis Plus libretro port";
    homepage = "https://github.com/libretro/Genesis-Plus-GX";
    license = lib.licenses.unfreeRedistributable;
  };
}
