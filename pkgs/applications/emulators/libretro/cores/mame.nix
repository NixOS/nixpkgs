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
<<<<<<< HEAD
  version = "0-unstable-2025-12-21";
=======
  version = "0-unstable-2025-11-01";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame";
<<<<<<< HEAD
    rev = "00cd2b406b2498139980a20145691d6769f83dae";
    hash = "sha256-CraC2iwAkqRcu5EJQuUckg4Xo+lPTNvhuDgbUDRfKeU=";
=======
    rev = "a90e86e100f79533f257ac2b30ccefe26a76daad";
    hash = "sha256-BD5DFl9EzSgnKBjF/TPXL8yvoyc3B1Ktzcwug8CEK38=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
