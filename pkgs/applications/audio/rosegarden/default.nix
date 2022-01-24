{ lib
, stdenv
, fetchurl
, cmake
, makedepend
, perl
, pkg-config
, qttools
, wrapQtAppsHook
, dssi
, fftwSinglePrec
, ladspaH
, ladspaPlugins
, libjack2
, alsa-lib
, liblo
, libsamplerate
, libsndfile
, lirc
, lrdf
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "rosegarden";
  version = "20.12";

  src = fetchurl {
    url = "mirror://sourceforge/rosegarden/${pname}-${version}.tar.bz2";
    sha256 = "sha256-iGaEr8WFipV4I00fhFGI2xMBFPf784IIxNXs2hUTHFs=";
  };

  postPhase = ''
    substituteInPlace src/CMakeLists.txt --replace svnheader svnversion
  '';

  nativeBuildInputs = [ cmake makedepend perl pkg-config qttools wrapQtAppsHook ];

  buildInputs = [
    dssi
    fftwSinglePrec
    ladspaH
    ladspaPlugins
    libjack2
    liblo
    libsamplerate
    libsndfile
    lirc
    lrdf
    qtbase
    alsa-lib
  ];

  meta = with lib; {
    homepage = "https://www.rosegardenmusic.com/";
    description = "Music composition and editing environment";
    longDescription = ''
      Rosegarden is a music composition and editing environment based around
      a MIDI sequencer that features a rich understanding of music notation
      and includes basic support for digital audio.

      Rosegarden is an easy-to-learn, attractive application that runs on Linux,
      ideal for composers, musicians, music students, and small studio or home
      recording environments.
    '';
    maintainers = with maintainers; [ lebastr ];
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
