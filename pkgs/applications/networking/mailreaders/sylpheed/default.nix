{ sslSupport ? true
, imageSupport ? true
, stdenv, fetchurl, gtk, openssl ? null, gdkpixbuf ? null
}:

assert gtk != null;
assert sslSupport -> openssl != null;
assert imageSupport -> gdkpixbuf != null;

stdenv.mkDerivation {
  name = "sylpheed-1.0.0-pre-beta3";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/sylpheed-1.0.0beta3.tar.bz2;
    md5 = "44d98cc4ed490dfdb92016b7689396cf";
  };

  inherit sslSupport imageSupport;

  inherit gtk;
  openssl = if sslSupport then openssl else null;
  gdkpixbuf = if imageSupport then gdkpixbuf else null;
}
