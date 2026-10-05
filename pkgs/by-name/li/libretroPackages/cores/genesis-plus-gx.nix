{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "genesis-plus-gx";
  version = "0-unstable-2026-09-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "Genesis-Plus-GX";
    rev = "c2838c7dc4236fc2fe94e5dbd08b41486067918e";
    hash = "sha256-sqic7mFeuhmW8fPB2WaEE1CJxSxB0pgFzoWX+DPirqM=";
  };

  meta = {
    description = "Enhanced Genesis Plus libretro port";
    homepage = "https://github.com/libretro/Genesis-Plus-GX";
    license = lib.licenses.unfreeRedistributable;
  };
}
