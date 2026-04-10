{
  lib,
  fetchFromGitHub,
  libGL,
  libGLU,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vecx";
  version = "0-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-vecx";
    rev = "eacee1f6f029688b043ed802cece29dd3c320e21";
    hash = "sha256-2OlacvnJWcfTA8l91IBvuoUgd1HAs5ZHCbBGfaTGCyg=";
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
