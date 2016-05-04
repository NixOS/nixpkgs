{ stdenv, fetchurl, alsaLib, libjack2, dbus, qt5 }:

stdenv.mkDerivation rec {
  version = "0.4.2";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "0pmgkqgkapbma42zqb5if4ngmj183rxl8bhjm7mhyhgq4bzll76g";
  };

  buildInputs = [ 
    qt5.full
    qt5.qtx11extras
    alsaLib 
    libjack2
    dbus 
  ];

  configureFlags = "--enable-jack-version";

  meta = with stdenv.lib; {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = http://qjackctl.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
