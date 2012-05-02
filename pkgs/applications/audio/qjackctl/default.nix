{ stdenv, fetchurl, qt4, alsaLib, jackaudio, dbus }:

stdenv.mkDerivation rec {
  version = "0.3.8";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "1rbipbknq7f8qfma33vwfv2ar3vxkz1p1ykp5mx6nirmcn1nj247";
  };

  buildInputs = [ qt4 alsaLib jackaudio dbus ];

  meta = {
    description = "qt jackd control gui tool";
    homepage = http://qjackctl.sourceforge.net/;
    license = "GPL";
  };
}
