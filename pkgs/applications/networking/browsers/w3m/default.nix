{ stdenv, fetchurl
, sslSupport ? true
, graphicsSupport ? false
, ncurses, openssl ? null, boehmgc, gettext, zlib, gdkpixbuf ? null
}:

assert sslSupport -> openssl != null;
assert graphicsSupport -> gdkpixbuf != null;

stdenv.mkDerivation {
  name = "w3m-0.5.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/w3m-0.5.1.tar.gz;
    md5 = "0678b72e07e69c41709d71ef0fe5da13";
  };
  inherit openssl boehmgc;
  buildInputs = [
    ncurses boehmgc gettext zlib
    (if sslSupport then openssl else null)
    (if graphicsSupport then gdkpixbuf else null)
  ];
  patches = [./bsd.patch];
}
