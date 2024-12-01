{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2024-09-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "e226068f979cd8fbfc3be9780d16cfb1405095b0";
    hash = "sha256-2G5EzcDJkEhaN+nXi/wu3+Ejim04ZzOr+LW69cLAEuM=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
