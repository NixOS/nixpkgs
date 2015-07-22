{stdenv, fetchurl, pkgconfig, xlibs, libpng, xineLib, readline, ncurses, curl
, lirc, shared_mime_info, libjpeg }:

stdenv.mkDerivation rec {
  name = "xine-ui-0.99.9";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "18liwmkbj75xs9bipw3vr67a7cwmdfcp04v5lph7nsjlkwhq1lcd";
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
