{ stdenv, fetchurl, qt4, jackaudio, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "1230yf49qfw540yvp5n7sh6mf3k8590pzwc5mragd3nd6k6apgw9";
  };

  buildInputs = [ qt4 jackaudio lv2 ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = http://synthv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}