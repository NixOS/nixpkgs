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
  version = "0-unstable-2025-04-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-psx-libretro";
    rev = "5d2137e5f15db3b52583e8246bcf2669cebb147b";
    hash = "sha256-Gu5rubuNsMWOCNaNrqRR/hoErmhYdGC+9o/xDXuaWuM=";
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
