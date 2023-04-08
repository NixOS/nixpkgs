{ lib, stdenv, fetchurl, pkg-config
, libX11, libXmu, libXpm, gtk2, libpng, libjpeg, libtiff, librsvg, gdk-pixbuf, gdk-pixbuf-xlib
}:

stdenv.mkDerivation rec {
  pname = "fbpanel";
  version = "6.1";
  src = fetchurl {
    url = "mirror://sourceforge/fbpanel/${pname}-${version}.tbz2";
    sha256 = "e14542cc81ea06e64dd4708546f5fd3f5e01884c3e4617885c7ef22af8cf3965";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ libX11 libXmu libXpm gtk2 libpng libjpeg libtiff librsvg gdk-pixbuf gdk-pixbuf-xlib.dev ];

  preConfigure = "patchShebangs .";

  postConfigure = ''
    substituteInPlace config.mk \
      --replace "CFLAGSX =" "CFLAGSX = -I${gdk-pixbuf-xlib.dev}/include/gdk-pixbuf-2.0"
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: plugin.o:(.bss+0x0): multiple definition of `stam'; panel.o:(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";
  NIX_LDFLAGS="-lX11";

  meta = with lib; {
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
