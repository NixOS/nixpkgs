{ stdenv, fetchurl, libmatchbox, pkgconfig}:

stdenv.mkDerivation rec {
  name = "matchbox-1.2";

  buildInputs = [ libmatchbox pkgconfig ];

  src = fetchurl {
    url = http://matchbox-project.org/sources/matchbox-window-manager/1.2/matchbox-window-manager-1.2.tar.bz2;
    sha256 = "1zyfq438b466ygcz78nvsmnsc5bhg4wcfnpxb43kbkwpyx53m8l1";
  };

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = http://matchbox-project.org/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
