args: with args;

stdenv.mkDerivation rec {
  name = "bitlbee-1.2.1";
  src = fetchurl {
    url = "mirror://bitlbee/src/" + name + ".tar.gz";
    sha256 = "01ld349f5k89lk6j7xn4sdbbf1577kp845vmnj3sfaza9s1fhm26";
  };

  buildInputs = [ gnutls glib pkgconfig ];

  meta = {
    description = ''BitlBee, an IRC to other chat networks gateway.'';
    homepage = http://www.bitlbee.org/;
    license = "GPL";
  };
}
