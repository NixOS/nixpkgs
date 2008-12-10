{ stdenv, fetchurl
, sslSupport ? true
, graphicsSupport ? false
, ncurses, openssl ? null, boehmgc, gettext, zlib, gdkpixbuf ? null
}:

assert sslSupport -> openssl != null;
assert graphicsSupport -> gdkpixbuf != null;

stdenv.mkDerivation {
  name = "w3m-0.5.2";

  src = fetchurl {
    url = mirror://sourceforge/w3m/w3m-0.5.2.tar.gz;
    md5 = "ba06992d3207666ed1bf2dcf7c72bf58";
  };

  buildInputs = [ncurses boehmgc gettext zlib]
    ++ stdenv.lib.optional sslSupport openssl
    ++ stdenv.lib.optional graphicsSupport gdkpixbuf;

  configureFlags = "--with-ssl=${openssl} --with-gc=${boehmgc}";

  preConfigure = ''
    substituteInPlace ./configure --replace /usr /no-such-path
  '';

  meta = {
    homepage = http://w3m.sourceforge.net/;
    description = "A text-mode web browser";
  };
}
