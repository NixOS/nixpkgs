{ stdenv, fetchurl, pkgconfig
, libX11, libXmu, libXpm, gtk2, libpng, libjpeg, libtiff, librsvg, gdk-pixbuf, gdk-pixbuf-xlib
}:

stdenv.mkDerivation rec {
  pname = "fbpanel";
  version = "6.1";
  src = fetchurl {
    url = "mirror://sourceforge/fbpanel/${pname}-${version}.tbz2";
    sha256 = "e14542cc81ea06e64dd4708546f5fd3f5e01884c3e4617885c7ef22af8cf3965";
  };
  buildInputs =
    [ pkgconfig libX11 libXmu libXpm gtk2 libpng libjpeg libtiff librsvg gdk-pixbuf gdk-pixbuf-xlib.dev ];

  preConfigure = "patchShebangs .";

  postConfigure = ''
    substituteInPlace config.mk \
      --replace "CFLAGSX =" "CFLAGSX = -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
  '';

  NIX_LDFLAGS="-lX11";

  meta = with stdenv.lib; {
    description = "A stand-alone panel";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

  passthru = {
    updateInfo = {
      downloadPage = "fbpanel.sourceforge.net";
    };
  };
}
