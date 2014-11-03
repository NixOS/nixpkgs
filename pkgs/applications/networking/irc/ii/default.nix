{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ii-1.7";
  
  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "176cqwnn6h7w4kbfd66hzqa243l26pqp2b06bii0nmnm0rkaqwis";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = http://tools.suckless.org/ii/;
    license = stdenv.lib.licenses.mit;
    description = "Irc it, simple FIFO based irc client";
  };
}
