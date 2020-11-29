{ stdenv, mkDerivation, fetchurl
, pkg-config, alsaLib, libjack2, dbus, qtbase, qttools, qtx11extras
# Enable jack session support
, jackSession ? false
}:

mkDerivation rec {
  version = "0.6.3";
  pname = "qjackctl";

  # some dependencies such as killall have to be installed additionally

  src = fetchurl {
    url = "mirror://sourceforge/qjackctl/${pname}-${version}.tar.gz";
    sha256 = "0zbb4jlx56qvcqyhx34mbagkqf3wbxgj84hk0ppf5cmcrxv67d4x";
  };

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    alsaLib
    libjack2
    dbus
  ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "--enable-jack-version"
    (stdenv.lib.strings.enableFeature jackSession "jack-session")
  ];

  meta = with stdenv.lib; {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = "http://qjackctl.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
