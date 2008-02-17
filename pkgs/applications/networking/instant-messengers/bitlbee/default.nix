args: with args;

stdenv.mkDerivation rec {
  name = "bitlbee-1.0.4";
  src = fetchurl {
    url = "mirror://bitlbee/src/" + name + ".tar.gz";
    sha256 = "072vdpz4z3bmskm04crrkj946hj0gnnd6w0vqrb7xmj1lrzg68vg";
  };

  buildInputs = [ gnutls glib pkgconfig ];

  meta = {
    description = ''BitlBee, an IRC to other chat networks gateway.'';
    homepage = http://www.bitlbee.org/;
    license = "GPL";
  };
}
