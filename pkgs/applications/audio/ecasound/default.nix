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
  name = "ecasound-${version}";
  version = "2.9.1";

  src = fetchurl {
    url = "https://ecasound.seul.org/download/ecasound-${version}.tar.gz";
    sha256 = "1wyws3xc4f9pglrrqv6k9137sarv4asizqrxz8h0dn44rnzfiz1r";
  };

  buildInputs = [ alsaLib audiofile libjack2 liblo liboil libsamplerate libsndfile lilv lv2 ];

  meta = {
    description = "Ecasound is a software package designed for multitrack audio processing";
    license = with stdenv.lib.licenses;  [ gpl2 lgpl21 ];
    homepage = http://nosignal.fi/ecasound/;
  };
}
