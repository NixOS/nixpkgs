{ lib, stdenv
, fetchgit
, automake
, autoreconfHook
, lv2
, pkg-config
, qt5
, alsa-lib
, libjack2
}:

stdenv.mkDerivation rec {
  pname = "qmidiarp";
  version = "0.6.5";

  src = fetchgit {
    url = "https://git.code.sf.net/p/qmidiarp/code";
    sha256 = "1g2143gzfbihqr2zi3k2v1yn1x3mwfbb2khmcd4m4cq3hcwhhlx9";
    rev = "qmidiarp-${version}";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    lv2
    libjack2
  ] ++ (with qt5; [
    qttools
  ]);

  meta = with lib; {
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
