{ stdenv, fetchurl, ncurses, gzip
, sslSupport ? true, openssl ? null
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "lynx-2.8.8";
  
  src = fetchurl {
    url = http://lynx.isc.org/lynx2.8.8/lynx2.8.8.tar.bz2;
    sha256 = "1rxysl08acqll5b87368f04kckl8sggy1qhnq59gsxyny1ffg039";
  };
  
  configureFlags = if sslSupport then "--with-ssl=${openssl}" else "";
  
  buildInputs = [ ncurses gzip ];
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
