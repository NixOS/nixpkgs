{ sslSupport ? true
, imageSupport ? true
, stdenv, fetchurl, gtk, openssl ? null, gdkpixbuf ? null
}:

assert gtk != null;
assert sslSupport -> openssl != null;
assert imageSupport -> gdkpixbuf != null;

stdenv.mkDerivation {
  name = "sylpheed-1.0.4";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/v1.0/sylpheed-1.0.4.tar.bz2;
    md5 = "e47b275c281335d09201503af2115eaa";
  };

  inherit sslSupport imageSupport;

  inherit gtk;
  openssl = if sslSupport then openssl else null;
  gdkpixbuf = if imageSupport then gdkpixbuf else null;
}
