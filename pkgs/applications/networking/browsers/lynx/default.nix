{ stdenv, fetchurl, ncurses, gzip
, sslSupport ? true, openssl ? null
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "lynx-2.8.7";
  
  src = fetchurl {
    url = http://lynx.isc.org/lynx2.8.7/lynx2.8.7.tar.bz2;
    sha256 = "1baxwpdvak6nalr943g22z67r1d3fbibbkqvkvvar9xlvrs9gv20";
  };
  
  configureFlags = if sslSupport then "--with-ssl" else "";
  
  buildInputs = [ ncurses gzip ] ++ stdenv.lib.optional sslSupport openssl;
  nativeBuildInputs = [ ncurses ];

  crossAttrs = {
    configureFlags = "--enable-widec" +
      (if sslSupport then " --with-ssl" else "");
  };

  meta = {
    homepage = http://lynx.isc.org/;
    description = "A text-mode web browser";
  };
}
