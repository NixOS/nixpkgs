{ stdenv, mkDerivation, fetchurl, pkgconfig, alsaLib, libjack2, dbus, qtbase, qttools, qtx11extras }:

mkDerivation rec {
  version = "0.5.9";
  pname = "qjackctl";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${pname}-${version}.tar.gz";
    sha256 = "1saywsda9m124rmjp7i3n0llryaliabjxhqhvqr6dm983qy7pypk";
  };

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    alsaLib
    libjack2
    dbus
  ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [ "--enable-jack-version" ];

  meta = with stdenv.lib; {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = http://qjackctl.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
