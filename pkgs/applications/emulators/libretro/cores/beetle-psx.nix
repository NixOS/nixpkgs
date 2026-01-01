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
<<<<<<< HEAD
  version = "0-unstable-2025-12-28";
=======
  version = "0-unstable-2025-11-14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-psx-libretro";
<<<<<<< HEAD
    rev = "b923925b4ec924d3b2051298ae9eb3ae654d99db";
    hash = "sha256-zwCDU94vixCQwVK7fLCdLobizt0nCf/0ZzkUaQLnYDs=";
=======
    rev = "d6383bff89a93e02aad10a586e804829861c3de1";
    hash = "sha256-90NhPleaA/YnkQ0EDbvjIGOVn49m+LFy1ovw7/scqlc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
