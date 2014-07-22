{ stdenv, fetchurl, qt4, alsaLib, jack2, dbus }:

stdenv.mkDerivation rec {
  version = "0.3.10";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "0ch14y3p0x5ss28cpnqcxp42zb2w07d3l1n2sbrkgiz58iy97paw";
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
