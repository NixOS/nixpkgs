{ stdenv, fetchurl, pkgconfig, qt5, alsaLib, libjack2 }:

stdenv.mkDerivation rec {
  version = "0.4.2";
  name = "qmidinet-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qmidinet/${name}.tar.gz";
    sha256 = "1sdnd189db44xhl9p8pd8h4bsy8s0bn1y64lrdq7nb21mwg8ymcs";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [  qt5.qtbase qt5.qttools alsaLib libjack2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "A MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network";
    homepage = http://qmidinet.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
