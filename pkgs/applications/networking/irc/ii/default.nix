{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ii-1.6";
  
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0afccbcm7i9lfch5mwzs3l1ax79dg3g6rrw0z8rb7d2kn8wsckvr";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = http://tools.suckless.org/ii/;
    license = "MIT";
    description = "Irc it, simple FIFO based irc client";
  };
}
