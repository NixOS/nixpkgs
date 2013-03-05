{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutil, bison,
  xcbutilwm, libstartup_notification, libX11, pcre, libev, yajl, flex,
  libXcursor, coreutils, perl }:

stdenv.mkDerivation rec {
  name = "i3-${version}";
  version = "4.4";

  src = fetchurl {
    url = "http://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "06s8gzcxxh06zp1586kp4bxaj8yj5i9jacwg0nizbmmnx94mg1wr";
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
