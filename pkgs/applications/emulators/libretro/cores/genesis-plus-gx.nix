{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "genesis-plus-gx";
  version = "0-unstable-2026-07-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "Genesis-Plus-GX";
    rev = "fa4dca561e08d5be9077419f7b255e1da213ed21";
    hash = "sha256-FfO5LzCH0hYqiVpE2qPJhX4gOrXqqYCoW4XRbz93La4=";
  };

  meta = {
    description = "Enhanced Genesis Plus libretro port";
    homepage = "https://github.com/libretro/Genesis-Plus-GX";
    license = lib.licenses.unfreeRedistributable;
  };
}
