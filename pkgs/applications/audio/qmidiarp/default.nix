{ stdenv
, fetchgit
, automake
, autoreconfHook
, lv2
, pkg-config
, qt5
, alsaLib
, libjack2
}:

stdenv.mkDerivation rec {
  name = "qmidiarp";
  version = "0.6.5";

  src = fetchgit {
    url = "https://git.code.sf.net/p/qmidiarp/code";
    sha256 = "1g2143gzfbihqr2zi3k2v1yn1x3mwfbb2khmcd4m4cq3hcwhhlx9";
    rev = "qmidiarp-0.6.5";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsaLib
    lv2
    libjack2
  ] ++ (with qt5; [
    qttools
  ]);

  meta = with stdenv.lib; {
    description = "An advanced MIDI arpeggiator";
    longDescription = ''
      An advanced MIDI arpeggiator, programmable step sequencer and LFO for Linux.
      It can hold any number of arpeggiator, sequencer, or LFO modules running in
      parallel.
    '';

    homepage = "http://qmidiarp.sourceforge.net";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sjfloat ];
  };
}
