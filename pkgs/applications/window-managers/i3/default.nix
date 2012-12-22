{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutil, bison,
  xcbutilwm, libstartup_notification, libX11, pcre, libev, yajl, flex,
  libXcursor, coreutils, perl }:

stdenv.mkDerivation rec {
  name = "i3-${version}";
  version = "4.3";

  src = fetchurl {
    url = "http://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "895bf586092535efb2bc723ba599c71a027768115e56052f111fc8bb148db925";
  };

  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutil bison xcbutilwm
    libstartup_notification libX11 pcre libev yajl flex libXcursor perl ];

  patchPhase = ''
    sed -i -e '/^# Pango/,/^$/d' common.mk
    patchShebangs .
  '';

  configurePhase = "makeFlags=PREFIX=$out";

  meta = {
    description = "i3 is a tiling window manager";
    homepage = "http://i3wm.org";
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = stdenv.lib.licenses.bsd3;
  };

}
