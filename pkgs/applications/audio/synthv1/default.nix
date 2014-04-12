{ stdenv, fetchurl, qt4, jackaudio, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "1j1x8n3rlwrh373wqmm6mj3cgyk3apvnpqygx1700fl4cf249agl";
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