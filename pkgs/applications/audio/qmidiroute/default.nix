{ stdenv, fetchurl, pkgconfig, qt4, alsaLib }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "qmidiroute-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/alsamodular/QMidiRoute/${version}/${name}.tar.gz";
    sha256 = "0vmjwarsxr5540rafhmdcc62yarf0w2l05bjjl9s28zzr5m39z3n";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ qt4 alsaLib ];

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
