{ stdenv, fetchurl, qt4, jackaudio, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "1xj4dk1g546f9fv2c4i7g3f1axrxfrxzk9w1nidhj3686j79nyry";
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