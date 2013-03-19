{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutil,
  xcbutilwm, libstartup_notification, libX11, pcre, libev, yajl,
  libXcursor, coreutils, perl, pango }:

stdenv.mkDerivation rec {
  name = "i3-${version}";
  version = "4.5";

  src = fetchurl {
    url = "http://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "1kiffcbvvjljqchw9ffgy9s8f9z06i8805jvjas58q5i2yxl5kcy";
  };

  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutil xcbutilwm
    libstartup_notification libX11 pcre libev yajl libXcursor perl pango ];

  patchPhase = ''
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
