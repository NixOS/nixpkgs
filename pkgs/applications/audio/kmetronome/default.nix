{ lib, stdenv, fetchurl, cmake, pkg-config, qttools, alsaLib, drumstick, qtbase, qtsvg }:

stdenv.mkDerivation rec {
  pname = "kmetronome";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1ln0nm24w6bj7wc8cay08j5azzznigd39cbbw3h4skg6fxd8p0s7";
  };

  nativeBuildInputs = [ cmake pkg-config qttools ];

  buildInputs = [ alsaLib drumstick qtbase qtsvg ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://kmetronome.sourceforge.io/";
    description = "ALSA MIDI metronome with Qt interface";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
