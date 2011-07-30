{ stdenv, fetchurl, qt4, alsaLib, jackaudio, dbus }:

stdenv.mkDerivation rec {
  version = "0.3.7";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "1gynym21d8d4d38qyl817qg0v8360brcpga4wcdapccbgpaz3c28";
  };

  buildInputs = [ qt4 alsaLib jackaudio dbus ];

  meta = {
    description = "qt jackd control gui tool";
    homepage = http://qjackctl.sourceforge.net/;
    license = "GPL";
  };
}
