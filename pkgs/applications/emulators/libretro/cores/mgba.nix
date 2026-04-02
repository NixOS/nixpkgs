{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2026-03-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "6ab29fed1b5139f19ac98c523fd4a6a7f0b30e38";
    hash = "sha256-6cCd2tuj2kXTL1w0DUPodaLU0ivNjPyKGytgxrjlwb0=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
