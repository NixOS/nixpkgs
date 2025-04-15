{
  lib,
  libGL,
  libGLU,
  fetchFromGitHub,
  mkLibretroCore,
  withHw ? false,
}:
mkLibretroCore {
  core = "mednafen-psx" + lib.optionalString withHw "-hw";
  version = "0-unstable-2025-04-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-psx-libretro";
    rev = "90c09d4b8e6923a22538c35f68ace2d9fead134d";
    hash = "sha256-eVoKmGE3N8uePcNpxWjAjgUjTIfEHZR3K2FLtQtLp+M=";
  };

  extraBuildInputs = lib.optionals withHw [
    libGL
    libGLU
  ];

  makefile = "Makefile";
  makeFlags = [
    "HAVE_HW=${if withHw then "1" else "0"}"
    "HAVE_LIGHTREC=1"
  ];

  meta = {
    description =
      "Port of Mednafen's PSX Engine core to libretro"
      + lib.optionalString withHw " (with hardware acceleration support)";
    homepage = "https://github.com/libretro/beetle-psx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
