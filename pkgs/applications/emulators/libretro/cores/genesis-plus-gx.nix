{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "genesis-plus-gx";
  version = "0-unstable-2025-11-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "Genesis-Plus-GX";
    rev = "65cd61cc262a8685d4f29ebcb7df2a40ed988e26";
    hash = "sha256-QC4xGdZglsrbNjfGA+XQ/iD5eTFvDLtrAbWYCkb5z1s=";
  };

  meta = {
    description = "Enhanced Genesis Plus libretro port";
    homepage = "https://github.com/libretro/Genesis-Plus-GX";
    license = lib.licenses.unfreeRedistributable;
  };
}
