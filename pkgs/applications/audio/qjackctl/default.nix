{ stdenv, fetchurl, qt4, alsaLib, jack2, dbus }:

stdenv.mkDerivation rec {
  version = "0.3.12";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "14yvnc4k3hwsjflg8b2d04bc63pdl0gyqjc7vl6rdn29nbr23zwc";
  };

  buildInputs = [ qt4 alsaLib jack2 dbus ];

  configureFlags = "--enable-jack-version";

  meta = {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = http://qjackctl.sourceforge.net/;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
