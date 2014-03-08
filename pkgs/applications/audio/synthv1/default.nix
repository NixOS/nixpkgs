{ stdenv, fetchurl, qt4, jackaudio, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "0zyxja1s74fr95qbwsyykggs3af2ndm2hz1l0avb645xgm93vcfv";
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