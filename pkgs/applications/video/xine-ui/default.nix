{stdenv, fetchurl, pkgconfig, xlibs, xineLib, libpng, readline, ncurses, curl}:

stdenv.mkDerivation {
  name = "xine-ui-0.99.5";
  
  src = fetchurl {
    url = mirror://sourceforge/xine/xine-ui-0.99.5.tar.gz;
    sha256 = "07jywadk6fhk3wn1j9m0cfa0zy0i17kz0nyyxwa3shvhznfals0k";
  };
  
  buildInputs =
    [ pkgconfig xineLib libpng readline ncurses curl
      xlibs.xlibs xlibs.libXext xlibs.libXv xlibs.libXxf86vm xlibs.libXtst xlibs.inputproto
      xlibs.libXinerama xlibs.libXi
    ];

  preBuild = ''
    sed -e '/curl.types.h/d' -i *.c *.h */*.c */*.h */*/*.c */*/*.h
  '';

  configureFlags = "--with-readline=${readline}";
  
  NIX_LDFLAGS = "-lXext -lgcc_s";

  meta = { 
    homepage = http://www.xine-project.org/;
    description = "Xlib-based interface to Xine, a video player";
  };
}
