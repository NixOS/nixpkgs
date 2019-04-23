{ stdenv, fetchurl, pkgconfig, qt5, libjack2, alsaLib, liblo, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.9.6";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "1hcngk7mxfrqf8v3r759x3wd0p02nc3q83j8m3k58p408y3mx7nr";
  };

  buildInputs = [ qt5.qtbase qt5.qttools libjack2 alsaLib liblo lv2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = https://synthv1.sourceforge.io/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
