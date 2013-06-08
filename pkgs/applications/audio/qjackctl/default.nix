{ stdenv, fetchurl, qt4, alsaLib, jackaudio, dbus }:

stdenv.mkDerivation rec {
  version = "0.3.9";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "0a4s7lwd5b67qbwv1yck8bw6zz8ffx1gza5fwflfqrfcfl3dds2y";
  };

  buildInputs = [ qt4 alsaLib jackaudio dbus ];

  configureFlags = "--enable-jack-version";

  meta = {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = http://qjackctl.sourceforge.net/;
    license = "GPL";
  };
}
