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
  version = "0-unstable-2026-10-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-psx-libretro";
    rev = "e57860d82faa953dc0fc10f201fd583739bc2f7d";
    hash = "sha256-/VvODoayn4/+sI0MKZWrXeVTRHRNrCnqNMsTyvaf9Hk=";
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
