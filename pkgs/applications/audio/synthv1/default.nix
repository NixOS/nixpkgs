{ stdenv, fetchurl, qt4, libjack2, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "19zyvrvnmi7ahwg121vl2q17j9y8ln6lvpj5wxxcwif5538q75iw";
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
