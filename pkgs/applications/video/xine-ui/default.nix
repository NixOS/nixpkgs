{stdenv, fetchurl, pkgconfig, x11, xineLib, libpng}:

stdenv.mkDerivation {
  name = "xine-ui-0.99.5";
  src = fetchurl {
    url = mirror://sourceforge/xine/xine-ui-0.99.5.tar.gz;
    sha256 = "07jywadk6fhk3wn1j9m0cfa0zy0i17kz0nyyxwa3shvhznfals0k";
  };
  buildInputs = [
    pkgconfig x11 xineLib libpng
    (if xineLib.xineramaSupport then xineLib.libXinerama else null)
  ];
  configureFlags = "--without-readline --disable-xft";

  meta = {
    description = "Xlib-based interface to Xine, a video player";
  };
}
