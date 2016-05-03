{ stdenv, fetchurl, libmatchbox, pkgconfig}:

stdenv.mkDerivation rec {
  name = "matchbox-${version}";
  version = "1.2";

  buildInputs = [ libmatchbox pkgconfig ];

  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/matchbox/matchbox-window-manager/${version}/matchbox-window-manager-${version}.tar.bz2";
    sha256 = "1zyfq438b466ygcz78nvsmnsc5bhg4wcfnpxb43kbkwpyx53m8l1";
  };

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = http://matchbox-project.org/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
