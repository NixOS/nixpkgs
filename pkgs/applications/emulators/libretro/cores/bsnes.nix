{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bsnes";
  version = "0-unstable-2025-01-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-libretro";
    rev = "05e820a436d2e2cbbb1b871400f84a96e76e2359";
    hash = "sha256-jq1W1OrltfTc4WEnEDZSNQUPSWfnUtzrOtiA4fzlIpk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of bsnes to libretro";
    homepage = "https://github.com/libretro/bsnes-libretro";
    license = lib.licenses.gpl3Only;
  };
}
