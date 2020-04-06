{stdenv, fetchurl, pkgconfig, xorg, libpng, xineLib, readline, ncurses, curl
, lirc, shared-mime-info, libjpeg }:

stdenv.mkDerivation rec {
  name = "xine-ui-0.99.12";

  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "10zmmss3hm8gjjyra20qhdc0lb1m6sym2nb2w62bmfk8isfw9gsl";
  };

  nativeBuildInputs = [ pkgconfig shared-mime-info ];

  buildInputs =
    [ xineLib libpng readline ncurses curl lirc libjpeg
      xorg.xlibsWrapper xorg.libXext xorg.libXv xorg.libXxf86vm xorg.libXtst xorg.xorgproto
      xorg.libXinerama xorg.libXi xorg.libXft
    ];

  patchPhase = ''sed -e '/curl\/types\.h/d' -i src/xitk/download.c'';

  configureFlags = [ "--with-readline=${readline.dev}" ];

  LIRC_CFLAGS="-I${lirc}/include";
  LIRC_LIBS="-L ${lirc}/lib -llirc_client";
#NIX_LDFLAGS = "-lXext -lgcc_s";

  meta = with stdenv.lib; {
    homepage = http://www.xine-project.org/;
    description = "Xlib-based interface to Xine, a video player";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
