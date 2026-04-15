{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pcsx-rearmed";
  version = "0-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "pcsx_rearmed";
    rev = "13f09ce0e3eb375e02879c51926d2b7c54e5f86b";
    hash = "sha256-WjdliWglIYGI1X9jGq5LqCBLijlR56TOwiVmJjCTi8M=";
  };

  dontConfigure = true;

  meta = {
    description = "Port of PCSX ReARMed to libretro";
    homepage = "https://github.com/libretro/pcsx_rearmed";
    license = lib.licenses.gpl2Only;
  };
}
