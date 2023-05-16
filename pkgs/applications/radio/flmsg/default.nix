{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, pkg-config
}:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "4.0.22";
=======
  version = "4.0.20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "flmsg";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-ueOkhmxrd4OT5g8z78TWUZuxT5SbF9300UWe7UByfD0=";
=======
    sha256 = "sha256-TsYwd2uUGJsweiKigTWBPXA7PtItZeIOxKk3lV3sy24=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Digital modem message program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
  };
}
