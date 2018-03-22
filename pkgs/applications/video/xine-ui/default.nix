{stdenv, fetchurl, pkgconfig, xorg, libpng, xineLib, readline, ncurses, curl
, lirc, shared-mime-info, libjpeg }:

stdenv.mkDerivation rec {
  name = "xine-ui-0.99.9";
  
  src = fetchurl {
    url = "mirror://sourceforge/xine/${name}.tar.xz";
    sha256 = "18liwmkbj75xs9bipw3vr67a7cwmdfcp04v5lph7nsjlkwhq1lcd";
  };
  
  nativeBuildInputs = [ pkgconfig shared-mime-info ];

  buildInputs =
    [ xineLib libpng readline ncurses curl lirc libjpeg
      xorg.xlibsWrapper xorg.libXext xorg.libXv xorg.libXxf86vm xorg.libXtst xorg.inputproto
      xorg.libXinerama xorg.libXi xorg.libXft
    ];

  patchPhase = ''sed -e '/curl\/types\.h/d' -i src/xitk/download.c'';

  configureFlags = "--with-readline=${readline.dev}";
  
  LIRC_CFLAGS="-I${lirc}/include";
  LIRC_LIBS="-L ${lirc}/lib -llirc_client";
#NIX_LDFLAGS = "-lXext -lgcc_s";

  meta = { 
    homepage = http://www.xine-project.org/;
    description = "Xlib-based interface to Xine, a video player";
    platforms = stdenv.lib.platforms.linux;
  };
}
