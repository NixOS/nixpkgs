{
  lib,
  alsa-lib,
  fetchFromGitHub,
  gcc12Stdenv,
  libGL,
  libGLU,
  mkLibretroCore,
  portaudio,
  python3,
  xorg,
}:
mkLibretroCore {
  core = "same_cdi";
  version = "0-unstable-2023-02-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "same_cdi";
    rev = "54cf493c2dee4c46666059c452f8aaaa0bd7c8e0";
    hash = "sha256-/+4coMzj/o82Q04Z65DQiPaykK6N56W6PRQLtyJOd8E=";
  };

  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [
    alsa-lib
    libGL
    libGLU
    portaudio
    xorg.libX11
  ];
  # FIXME = build fail with GCC13:
  # error = 'uint8_t' in namespace 'std' does not name a type; did you mean 'wint_t'?
  stdenv = gcc12Stdenv;

  meta = {
    description = "SAME_CDI is a libretro core to play CD-i games";
    homepage = "https://github.com/libretro/same_cdi";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
  };
}
