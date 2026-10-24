{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pcsx-rearmed";
  version = "0-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "pcsx_rearmed";
    rev = "c8816799b50388e61cfe237fe2cdbb7d8175f20a";
    hash = "sha256-KAl4SS2sut9U+OFm28ZpgORJk7hG0Mdae+KJlDisdjs=";
  };

  dontConfigure = true;

  meta = {
    description = "Port of PCSX ReARMed to libretro";
    homepage = "https://github.com/libretro/pcsx_rearmed";
    license = lib.licenses.gpl2Only;
  };
}
