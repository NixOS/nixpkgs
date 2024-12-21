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
  version = "0-unstable-2024-12-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-psx-libretro";
    rev = "80d3eba272cf6efab6b76e4dc44ea2834c6f910d";
    hash = "sha256-k6sJQ8HxIvb/aYfMi15taCR9wWV7o03xqvimDTHNc5I=";
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
