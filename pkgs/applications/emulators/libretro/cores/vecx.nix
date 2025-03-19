{
  lib,
  fetchFromGitHub,
  libGL,
  libGLU,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vecx";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-vecx";
    rev = "a103a212ca8644fcb5d76eac7cdec77223c4fb02";
    hash = "sha256-veCGW5mbR1V7cCzZ4BzDSdPZDycw4WNveie/DDVAzw8=";
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
