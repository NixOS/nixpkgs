{stdenv, fetchurl, pkgconfig, xlibs, libpng, xineLib, readline, ncurses, curl
, lirc, shared_mime_info, libjpeg }:

stdenv.mkDerivation rec {
  name = "xine-ui-0.99.7";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "1i3byriqav06b55kwzs4dkzrjw7mmmcv0rc7jzb52hn8qp8xz34x";
  };
  
  nativeBuildInputs = [ pkgconfig shared_mime_info ];

  buildInputs =
    [ xineLib libpng readline ncurses curl lirc libjpeg
      xlibs.xlibs xlibs.libXext xlibs.libXv xlibs.libXxf86vm xlibs.libXtst xlibs.inputproto
      xlibs.libXinerama xlibs.libXi xlibs.libXft
    ];

  patchPhase = ''sed -e '/curl\/types\.h/d' -i src/xitk/download.c'';

  configureFlags = "--with-readline=${readline}";
  
  LIRC_CFLAGS="-I${lirc}/include";
  LIRC_LIBS="-L ${lirc}/lib -llirc_client";
#NIX_LDFLAGS = "-lXext -lgcc_s";

  meta = { 
    homepage = http://www.xine-project.org/;
    description = "Xlib-based interface to Xine, a video player";
  };
}
