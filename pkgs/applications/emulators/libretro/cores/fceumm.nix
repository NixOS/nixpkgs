{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2025-04-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "80b887a7cd9c83def0eeb12b4d97e2feccb10e6c";
    hash = "sha256-AdDkbts8IAOIgTY1HsssXvUsdOuU8TgQNQURQMd2/IM=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
