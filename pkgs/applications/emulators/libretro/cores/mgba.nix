{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2024-11-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "747362c02d2e71ee7c363e8dcb240925be8af906";
    hash = "sha256-dBhdS6C1H02iwdYDVvJmkPWob81vpmQJdHUHJFAq2vo=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
