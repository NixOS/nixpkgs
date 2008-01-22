args: with args;
stdenv.mkDerivation {
  name = "xine-ui-0.99.5";
  src = fetchurl {
    url = mirror://sourceforge/xine/xine-ui-0.99.5.tar.gz;
    sha256 = "07jywadk6fhk3wn1j9m0cfa0zy0i17kz0nyyxwa3shvhznfals0k";
  };
  buildInputs = [
    pkgconfig x11 xineLib libpng libXext libXv readline ncurses libXxf86vm
	libXtst inputproto curl
    (if xineLib.xineramaSupport then xineLib.libXinerama else null)
  ];
  configureFlags = "--with-readline=${readline}";
  NIX_LDFLAGS="-L${libXext}/lib -lXext";

  meta = {
    description = "Xlib-based interface to Xine, a video player";
  };
}
