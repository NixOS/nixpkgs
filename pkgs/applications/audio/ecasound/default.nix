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
  version = "2.9.3";

  src = fetchurl {
    url = "https://ecasound.seul.org/download/ecasound-${version}.tar.gz";
    sha256 = "1m7njfjdb7sqf0lhgc4swihgdr4snkg8v02wcly08wb5ar2fr2s6";
  };

  buildInputs = [ alsaLib audiofile libjack2 liblo liboil libsamplerate libsndfile lilv lv2 ];

  meta = {
    description = "Ecasound is a software package designed for multitrack audio processing";
    license = with stdenv.lib.licenses;  [ gpl2 lgpl21 ];
    homepage = http://nosignal.fi/ecasound/;
  };
}
