{ sslSupport ? true
, stdenv, fetchurl, pkgconfig, gtk, glib, openssl ? null, gdkpixbuf ? null
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "sylpheed-2.1.3";

  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/v2.1/sylpheed-2.1.3.tar.bz2;
    md5 = "57f874501c5b0e52b8ec1959fe0359be";
  };

  buildInputs = [
    pkgconfig glib gtk
    (if sslSupport then openssl else null)
  ];

  configureFlags = [
    (if sslSupport then "--enable-ssl" else null)
  ];

  # Bug in Sylpheed: it makes direct X11 calls (e.g., XSync), but it
  # doesn't pass -lX11.  The linker finds the missing symbols
  # indirectly (through GTK etc.), but doesn't include libX11.so in
  # the RPATH.  Thus, the executable fails at runtime.
  NIX_LDFLAGS = "-lX11";
}
