args: with args;

stdenv.mkDerivation rec {
  name = "bitlbee-1.2";
  src = fetchurl {
    url = "mirror://bitlbee/src/" + name + ".tar.gz";
    sha256 = "ff69fa43445c833a34ea64c23178383e3abe98f2ec7e791ea0cf3913e4090bb8";
  };

  buildInputs = [ gnutls glib pkgconfig ];

  meta = {
    description = ''BitlBee, an IRC to other chat networks gateway.'';
    homepage = http://www.bitlbee.org/;
    license = "GPL";
  };
}
