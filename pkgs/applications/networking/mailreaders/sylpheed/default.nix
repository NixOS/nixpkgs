{ sslSupport ? true
, imageSupport ? true
, stdenv, fetchurl, gtk, openssl ? null, gdkpixbuf ? null
}:

assert gtk != null;
assert sslSupport -> openssl != null;
assert imageSupport -> gdkpixbuf != null;

stdenv.mkDerivation {
  name = "sylpheed-1.0.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/sylpheed-1.0.0.tar.bz2;
    md5 = "864c4fc581a5ab1c7af5e06153c76769";
  };

  inherit sslSupport imageSupport;

  inherit gtk;
  openssl = if sslSupport then openssl else null;
  gdkpixbuf = if imageSupport then gdkpixbuf else null;
}
