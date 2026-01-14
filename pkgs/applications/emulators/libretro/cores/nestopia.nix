{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-11-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "5deada54077fae87e2873f5ad9ef77e3ab7af5e1";
    hash = "sha256-3/e0wrJOaEdQ4Uz17r9KyLdCsyY7dqOpIyC0MPhqhdA=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
