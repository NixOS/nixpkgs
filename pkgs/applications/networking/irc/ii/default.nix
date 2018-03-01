{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ii-1.8";
  
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "1lk8vjl7i8dcjh4jkg8h8bkapcbs465sy8g9c0chfqsywbmf3ndr";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = https://tools.suckless.org/ii/;
    license = stdenv.lib.licenses.mit;
    description = "Irc it, simple FIFO based irc client";
    platforms = stdenv.lib.platforms.unix;
  };
}
