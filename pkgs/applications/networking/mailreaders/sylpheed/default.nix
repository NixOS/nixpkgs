{ sslSupport ? true
, imageSupport ? true
, stdenv, fetchurl, gtk, openssl ? null, gdkpixbuf ? null
}:

assert gtk != null;
assert sslSupport -> openssl != null;
assert imageSupport -> gdkpixbuf != null;

derivation {
  name = "sylpheed-0.9.10";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/sylpheed-0.9.10.tar.bz2;
    md5 = "4e2242436de3cf3977a1b25b1ddc4930";
  };

  inherit sslSupport imageSupport;

  inherit stdenv gtk;
  openssl = if sslSupport then openssl else null;
  gdkpixbuf = if imageSupport then gdkpixbuf else null;
}
