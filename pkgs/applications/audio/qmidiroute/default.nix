{ stdenv, fetchurl, pkgconfig, qt4, alsaLib }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "qmidiroute-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/alsamodular/QMidiRoute/${version}/${name}.tar.gz";
    sha256 = "11bfjz14z37v6hk2xyg4vrw423b5h3qgcbviv07g00ws1fgjygm2";
  };

  buildInputs = [ pkgconfig qt4 alsaLib ];

  meta = with stdenv.lib; {
    description = "MIDI event processor and router";
    longDescription = ''
    qmidiroute is a versatile MIDI event processor and router for the ALSA
    sequencer.  The graphical  interface  is  based  on  the  Qt4  toolkit.
    qmidiroute permits setting up an unlimited number of MIDI maps in which
    incoming events are selected, modified or even changed in  type  before
    being  directed  to  a  dedicated  ALSA  output  port. The maps work in
    parallel, and they are organized in tabs.
    '';

    license = licenses.gpl2;
    maintainers = [ maintainers.lebastr ];
    platforms = stdenv.lib.platforms.linux;
  };
}
