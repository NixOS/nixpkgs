{ sslSupport ? true
, imageSupport ? true
, stdenv, fetchurl, gtk, openssl ? null, gdkpixbuf ? null
}:

assert !isNull gtk;
assert sslSupport -> !isNull openssl;
assert imageSupport -> !isNull gdkpixbuf;

derivation {
  name = "sylpheed-0.9.8a";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/sylpheed-0.9.8a.tar.bz2;
    md5 = "6ac823f06d8fe4f265f37d9c96068e05";
  };

  sslSupport = sslSupport;
  imageSupport = imageSupport;

  stdenv = stdenv;
  gtk = gtk;
  openssl = if sslSupport then openssl else null;
  gdkpixbuf = if imageSupport then gdkpixbuf else null;
}
