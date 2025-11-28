{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pcsx-rearmed";
  version = "0-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "pcsx_rearmed";
    rev = "9059485691c44cb3a555464b06eddfb1082d586c";
    hash = "sha256-sm59Xo6bEiajbmRYbCNnWToDLpJPdaJhovJe+g+GWVg=";
  };

  dontConfigure = true;

  meta = {
    description = "Port of PCSX ReARMed to libretro";
    homepage = "https://github.com/libretro/pcsx_rearmed";
    license = lib.licenses.gpl2Only;
  };
}
