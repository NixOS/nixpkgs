{ stdenv, fetchurl, qt4, alsaLib, libjack2, dbus }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "0nj8c8vy00524hbjqwsqkliblcf9j7h46adk6v5np645pp2iqrav";
  };

  buildInputs = [ qt4 alsaLib libjack2 dbus ];

  configureFlags = "--enable-jack-version";

  meta = with stdenv.lib; {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = http://qjackctl.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
