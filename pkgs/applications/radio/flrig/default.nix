{ lib
, stdenv
, fetchurl
, fltk13
, libjpeg
, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "1.3.53";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "1m0fa891scpaf719002w9gpg1famx84kpzav1mw1fafmbzyvjw1i";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkgconfig
  ];

  meta = {
    description = "Digital modem rig control program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
  };
}
