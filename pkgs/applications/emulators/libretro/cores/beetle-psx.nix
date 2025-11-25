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
  version = "0-unstable-2025-11-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-psx-libretro";
    rev = "1420c90299b1d9f4ef59373b3e5fa538a1e17a65";
    hash = "sha256-w7Mcg80LiErWQdFiTfd+RTqJgCjH8qVf/N73KGOwyO4=";
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
