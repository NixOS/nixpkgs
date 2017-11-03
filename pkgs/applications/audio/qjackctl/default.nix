{ stdenv, fetchurl, pkgconfig, alsaLib, libjack2, dbus, qtbase, qttools, qtx11extras }:

stdenv.mkDerivation rec {
  version = "0.4.5";
  name = "qjackctl-${version}";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${name}.tar.gz";
    sha256 = "1dsavjfzz5bpzc80mvfs940w9f9f47cf4r9cqxnaqrl4xilsa3f5";
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
