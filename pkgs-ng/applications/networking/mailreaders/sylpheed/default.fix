{ sslSupport ? true
, imageSupport ? true
, stdenv, fetchurl, gtk, openssl ? null, gdkpixbuf ? null
}:

assert !isNull gtk;
assert sslSupport -> !isNull openssl;
assert imageSupport -> !isNull gdkpixbuf;

derivation {
  name = "sylpheed-0.9.7";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/sylpheed-0.9.7.tar.bz2;
    md5 = "399deb5abd52396d26d6475689a5ec3f";
  };

  sslSupport = sslSupport;
  imageSupport = imageSupport;

  stdenv = stdenv;
  gtk = gtk;
  openssl = if sslSupport then openssl else null;
  gdkpixbuf = if imageSupport then gdkpixbuf else null;
}
