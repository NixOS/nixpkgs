{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "genesis-plus-gx";
  version = "0-unstable-2026-08-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "Genesis-Plus-GX";
    rev = "a7985a9c4278ac352f8ca7bb4d3cc6b36e9e3e7d";
    hash = "sha256-uG4bGYsl4ZisaO7ICg/QdLv6CfV5cB4T56MMpLuu9QQ=";
  };

  meta = {
    description = "Enhanced Genesis Plus libretro port";
    homepage = "https://github.com/libretro/Genesis-Plus-GX";
    license = lib.licenses.unfreeRedistributable;
  };
}
