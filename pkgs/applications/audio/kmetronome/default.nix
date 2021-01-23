{ lib, stdenv, fetchurl, cmake, pkg-config, qttools, alsaLib, drumstick, qtbase, qtsvg }:

stdenv.mkDerivation rec {
  pname = "kmetronome";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0bzm6vzlm32kjrgn1nvp096b2d41ybys2sk145nhy992wg56v32s";
  };

  nativeBuildInputs = [ cmake pkg-config qttools ];

  buildInputs = [ alsaLib drumstick qtbase qtsvg ];

  meta = with lib; {
    homepage = "https://kmetronome.sourceforge.io/";
    description = "ALSA MIDI metronome with Qt interface";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
