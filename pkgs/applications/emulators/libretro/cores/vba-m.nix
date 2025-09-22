{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vbam";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vbam-libretro";
    rev = "379dd97301458a51fb69dd93ba21b64f81e01ef2";
    hash = "sha256-UbXSHdKfa91MpcYityo+aILbI0DfkLqZh8YfGcRx/BI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/libretro";

  meta = {
    description = "VBA-M libretro port";
    homepage = "https://github.com/libretro/vbam-libretro";
    license = lib.licenses.gpl2Only;
  };
}
