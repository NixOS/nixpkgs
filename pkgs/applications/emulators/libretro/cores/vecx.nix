{
  lib,
  fetchFromGitHub,
  libGL,
  libGLU,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vecx";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-vecx";
    rev = "8f671cc9d737f2890c3ce19e177e2984dcae121f";
    hash = "sha256-gNHPmoCiqWg7vWapWBPwHPPogiXCvXfkyqsHuudKHDg=";
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
