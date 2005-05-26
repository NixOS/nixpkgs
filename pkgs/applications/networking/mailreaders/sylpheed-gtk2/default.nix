{ sslSupport ? true
, stdenv, fetchurl, pkgconfig, gtk, glib, openssl ? null, gdkpixbuf ? null
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "sylpheed-1.9.11";

  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/v1.9/sylpheed-1.9.11.tar.bz2;
    md5 = "70191d0d98ea576b0d2e175055ced4c9";
  };

  buildInputs = [
    pkgconfig glib gtk
    (if sslSupport then openssl else null)
  ];

  configureFlags = [
    (if sslSupport then "--enable-ssl" else null)
  ];
}
