{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "ii";
  version = "1.8";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/${pname}-${version}.tar.gz";
    sha256 = "1lk8vjl7i8dcjh4jkg8h8bkapcbs465sy8g9c0chfqsywbmf3ndr";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = "https://tools.suckless.org/ii/";
    license = lib.licenses.mit;
    description = "Irc it, simple FIFO based irc client";
    platforms = lib.platforms.unix;
  };
}
