{ sslSupport ? true
, imageSupport ? true
, stdenv, fetchurl, gtk, openssl ? null, gdkpixbuf ? null
}:

assert gtk != null;
assert sslSupport -> openssl != null;
assert imageSupport -> gdkpixbuf != null;

stdenv.mkDerivation {
  name = "sylpheed-0.9.12";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://sylpheed.good-day.net/sylpheed/sylpheed-0.9.12.tar.bz2;
    md5 = "5deab7d65f8e19444902be3d82610e6b";
  };

  inherit sslSupport imageSupport;

  inherit gtk;
  openssl = if sslSupport then openssl else null;
  gdkpixbuf = if imageSupport then gdkpixbuf else null;
}
