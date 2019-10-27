{ stdenv
, fetchurl
, alsaLib
, audiofile
, libjack2
, liblo
, liboil
, libsamplerate
, libsndfile
, lilv
, lv2
}:

# TODO: fix readline, ncurses, lilv, liblo, liboil and python. See configure log.

stdenv.mkDerivation rec {
  pname = "ecasound";
  version = "2.9.2";

  src = fetchurl {
    url = "https://ecasound.seul.org/download/ecasound-${version}.tar.gz";
    sha256 = "15rcs28fq2wfvfs66p5na7adq88b55qszbhshpizgdbyqzgr2jf1";
  };

  buildInputs = [ alsaLib audiofile libjack2 liblo liboil libsamplerate libsndfile lilv lv2 ];

  meta = {
    description = "Ecasound is a software package designed for multitrack audio processing";
    license = with stdenv.lib.licenses;  [ gpl2 lgpl21 ];
    homepage = http://nosignal.fi/ecasound/;
  };
}
