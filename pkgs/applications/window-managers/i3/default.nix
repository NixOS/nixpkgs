{ fetchurl, stdenv, which, pkgconfig, libxcb, xcbutilkeysyms, xcbutil,
  xcbutilwm, libstartup_notification, libX11, pcre, libev, yajl,
  libXcursor, coreutils, perl, pango }:

stdenv.mkDerivation rec {
  name = "i3-${version}";
  version = "4.6";

  src = fetchurl {
    url = "http://i3wm.org/downloads/${name}.tar.bz2";
    sha256 = "1qand44hjqz84f2xzd0mmyk9vpsm7iwz6446s4ivdj6f86213lpm";
  };

  buildInputs = [ which pkgconfig libxcb xcbutilkeysyms xcbutil xcbutilwm
    libstartup_notification libX11 pcre libev yajl libXcursor perl pango ];

  patchPhase = ''
    patchShebangs .
  '';

  configurePhase = "makeFlags=PREFIX=$out";

  meta = with stdenv.lib; {
    description = "A tiling window manager";
    homepage    = "http://i3wm.org";
    maintainers = with maintainers; [ garbas modulistic ];
    license     = licenses.bsd3;
    platforms   = platforms.all;

    longDescription = ''
      A tiling window manager primarily targeted at advanced users and
      developers. Based on a tree as data structure, supports tiling,
      stacking, and tabbing layouts, handled dynamically, as well as
      floating windows. Configured via plain text file. Multi-monitor.
      UTF-8 clean.
    '';
  };

}

