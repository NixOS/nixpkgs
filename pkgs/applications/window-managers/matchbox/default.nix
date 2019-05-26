{ stdenv, fetchurl, pkgconfig, libmatchbox, libX11, libXext }:

stdenv.mkDerivation rec {
  name = "matchbox-${version}";
  version = "1.2";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmatchbox ];
  NIX_LDFLAGS = "-lX11 -L${libX11}/lib -lXext -L${libXext}/lib";

  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/matchbox/matchbox-window-manager/${version}/matchbox-window-manager-${version}.tar.bz2";
    sha256 = "1zyfq438b466ygcz78nvsmnsc5bhg4wcfnpxb43kbkwpyx53m8l1";
  };

  meta = {
    description = "X window manager for non-desktop embedded systems";
    homepage = "https://www.yoctoproject.org/software-item/matchbox/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
