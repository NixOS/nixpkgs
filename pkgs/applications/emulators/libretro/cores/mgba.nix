{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2025-10-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "c758314a639aa0066e7b65a8341448181b73c804";
    hash = "sha256-ev0vzLqZzOr5RW/jf07vXtBmYkcB2m+afADHFBH5zbQ=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
