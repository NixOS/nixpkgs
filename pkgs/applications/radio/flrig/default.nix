{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, eudev
, pkg-config
}:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "2.0.03";
=======
  version = "1.4.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-/5hOryoupl7MYWekx2hL3q+2GMXA6rohjvYy2XTkJBI=";
=======
    sha256 = "sha256-7aqjNbcAE1ATb5Zl+ziVb7O86nqlFwdpsYm9RoX51rg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    fltk13
    libjpeg
    eudev
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Digital modem rig control program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
  };
}
