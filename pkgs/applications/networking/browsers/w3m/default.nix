{ stdenv, fetchurl
, sslSupport ? true
, graphicsSupport ? false
, ncurses, openssl ? null, boehmgc, gettext, zlib, gdkpixbuf ? null
}:

assert sslSupport -> openssl != null;
assert graphicsSupport -> gdkpixbuf != null;

stdenv.mkDerivation {
  name = "w3m-0.5.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/w3m/w3m-0.5.2.tar.gz;
    md5 = "ba06992d3207666ed1bf2dcf7c72bf58";
  };
  inherit openssl boehmgc;
  buildInputs = [
    ncurses boehmgc gettext zlib
    (if sslSupport then openssl else null)
    (if graphicsSupport then gdkpixbuf else null)
  ];
  #patches = [./bsd.patch];
}
