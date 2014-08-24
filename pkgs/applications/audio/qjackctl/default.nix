{ stdenv, fetchurl, qt4, alsaLib, jack2, dbus }:

stdenv.mkDerivation rec {
  version = "0.3.11";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "1wjzrgx3n2asyxk6cnfcm34msaw84qvsqy08bd4qnghrgpl96hwl";
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
