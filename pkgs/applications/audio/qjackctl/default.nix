{ stdenv, fetchurl, alsaLib, libjack2, dbus, qtbase, qttools, qtx11extras }:

stdenv.mkDerivation rec {
  version = "0.4.3";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "01wyyynxy21kim0gplzvfij7275a1jz68hdx837d2j1w5x2w7zbb";
  };

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    alsaLib
    libjack2
    dbus
  ];

  configureFlags = [ "--enable-jack-version" ];

  meta = with stdenv.lib; {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = http://qjackctl.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
