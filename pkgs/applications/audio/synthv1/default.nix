{ stdenv, fetchurl, qt4, libjack2, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "0asjhz0xj1kwysvsj9q54r8j8fy7cnr408ygfpdhg7yn24rv67hh";
  };

  buildInputs = [ qt4 libjack2 lv2 ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = http://synthv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
