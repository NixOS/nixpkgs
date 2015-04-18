{ stdenv, fetchurl, qt4, jack2, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "07570mi7rjwkkvfzdw1jcbhpkpxpjp69xj7wfzng92rk2gz7yi8m";
  };

  buildInputs = [ qt4 jack2 lv2 ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = http://synthv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}