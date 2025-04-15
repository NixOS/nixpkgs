{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2025-04-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "b349f7f3e211bb7725f133d3818ab98da5059760";
    hash = "sha256-MNYpuipjnDl9GUl5qWGi5W5cFhUCd/weCKuTRdttKJ4=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
