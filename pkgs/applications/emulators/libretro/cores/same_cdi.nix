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
  version = "0-unstable-2025-01-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "same_cdi";
    rev = "7ee1d8e9cb4307b7cd44ee1dd757e9b3f48f41d5";
    hash = "sha256-EGE3NuO0gpZ8MKPypH8rFwJiv4QsdKuIyLKVuKTcvws=";
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
