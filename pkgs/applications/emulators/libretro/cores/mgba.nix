{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2025-07-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "affc86e4c07b6e1e8363e0bc1c5ffb813a2e32c9";
    hash = "sha256-4nKghnpMI1LuKOKc0vSknTuq+bA0wpBux/a5mGCyev8=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
