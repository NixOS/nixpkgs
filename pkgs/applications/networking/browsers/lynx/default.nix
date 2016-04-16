{ stdenv, fetchurl, ncurses, gzip
, sslSupport ? true, openssl ? null
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  name = "lynx-${version}";
  version = "2.8.8rel.2";
  
  src = fetchurl {
    url = "http://invisible-mirror.net/archives/lynx/tarballs/lynx${version}.tar.bz2";
    sha256 = "1rxysl08acqll5b87368f04kckl8sggy1qhnq59gsxyny1ffg039";
  };
  
  configureFlags = []
    ++ stdenv.lib.optionals sslSupport [ "--with-ssl=${openssl.dev}" ];
  
  buildInputs = [ ncurses gzip ];
  nativeBuildInputs = [ ncurses ];

  crossAttrs = {
    configureFlags = configureFlags ++ [ "--enable-widec" ];
  };

  meta = {
    homepage = http://lynx.isc.org/;
    description = "A text-mode web browser";
  };
}
