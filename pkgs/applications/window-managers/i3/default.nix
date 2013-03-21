{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutil,
  xcbutilwm, libstartup_notification, libX11, pcre, libev, yajl,
  libXcursor, coreutils, perl, pango }:

stdenv.mkDerivation rec {
  name = "i3-${version}";
  version = "4.5.1";

  src = fetchurl {
    url = "http://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "bae55f1c7c4a21d71aae182e4fab6038ba65ba4be5d1ceff9e269f4f74b823f2";
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
