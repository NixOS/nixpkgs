{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
  alsa-lib,
  libGLU,
  libGL,
}:
mkLibretroCore {
  core = "mame";
  version = "0-unstable-2026-02-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame";
    rev = "74731455f45c08d4f303c6d07c4f1cbf791d52b6";
    hash = "sha256-f0f0ajliLM2ZJjOpA7sk3pgA7LZ2JTEIl7+w/3TpFK0=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [
    alsa-lib
    libGLU
    libGL
  ];
  # Setting this is breaking compilation of src/3rdparty/genie for some reason
  makeFlags = [ "ARCH=" ];

  meta = {
    description = "Port of MAME to libretro";
    homepage = "https://github.com/libretro/mame";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
  };
}
