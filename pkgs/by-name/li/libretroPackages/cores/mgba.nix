{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2026-07-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "32de792178a3662cd0402c8568fccfaad4a764a1";
    hash = "sha256-Wz2qr657sF7D9R2jkHJLLs1BHkoKxYXd2rUAbroY5Rw=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
