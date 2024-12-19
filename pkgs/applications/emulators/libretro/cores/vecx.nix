{
  lib,
  fetchFromGitHub,
  libGL,
  libGLU,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vecx";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-vecx";
    rev = "0e48a8903bd9cc359da3f7db783f83e22722c0cf";
    hash = "sha256-lB8NSaxDbN2qljhI0M/HFDuN0D/wMhFUQXhfSdGHsHU=";
  };

  extraBuildInputs = [
    libGL
    libGLU
  ];

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/libretro-vecx";
    license = lib.licenses.gpl3Only;
  };
}
