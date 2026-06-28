{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pcsx-rearmed";
  version = "0-unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "pcsx_rearmed";
    rev = "d26eaee5c8fb47c1832b8bf32c1358d625da8a02";
    hash = "sha256-p8sPQDnxIBMuFD9nCtdFp1DEJwRuifgUrOFYdY1EfME=";
  };

  dontConfigure = true;

  meta = {
    description = "Port of PCSX ReARMed to libretro";
    homepage = "https://github.com/libretro/pcsx_rearmed";
    license = lib.licenses.gpl2Only;
  };
}
