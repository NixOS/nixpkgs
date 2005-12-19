{ sslSupport ? true
, gpgSupport ? false
, stdenv, fetchurl, pkgconfig, gtk, glib
, openssl ? null
, gpgme ? null
}:

assert sslSupport -> openssl != null;
assert gpgSupport -> gpgme != null;

stdenv.mkDerivation {
  name = "sylpheed-2.1.9";

  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/v2.1/sylpheed-2.1.9.tar.bz2;
    md5 = "fe05714e5037d56ccdcf4b36fe4e9346";
  };

  buildInputs = [
    pkgconfig glib gtk
    (if sslSupport then openssl else null)
    (if gpgSupport then gpgme else null)
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
