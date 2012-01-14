{stdenv, fetchurl, pkgconfig, xlibs, xineLib, libpng, readline, ncurses, curl
, lirc, xz, shared_mime_info }:

stdenv.mkDerivation rec {
  name = "xine-ui-0.99.6";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "1wwylnckm5kfq5fi154w8jqf5cwvp7c1ani15q7sgfrfdkmy7caf";
  };
  
  buildNativeInputs = [ xz pkgconfig shared_mime_info ];

  buildInputs =
    [ xineLib libpng readline ncurses curl lirc
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
