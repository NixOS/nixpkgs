{ stdenv, fetchurl, qt4, alsaLib, jackaudio }:

stdenv.mkDerivation {
  name = "qjackctl-0.3.3";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = http://downloads.sourceforge.net/qjackctl/qjackctl-0.3.3.tar.gz;
    sha256 = "1z9v208fs79ka6ni3p5v5xb0k5y1wqqm2a9cf903387b9p3fhpxj";
  };

  buildInputs = [ qt4 alsaLib jackaudio ];

  meta = { 
    description = "qt jackd control gui tool";
    homepage = http://qjackctl.sourceforge.net/;
    license = "GPL";
  };
}
