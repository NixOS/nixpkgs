{ stdenv, fetchurl, pkgconfig, qt5, libjack2, alsaLib, liblo, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.8.6";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "141ah1gnv5r2k846v5ay15q9q90h01p74240a56vlxqh20z43g92";
  };

  buildInputs = [ qt5.qtbase qt5.qttools libjack2 alsaLib liblo lv2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "An old-school 4-oscillator subtractive polyphonic synthesizer with stereo fx";
    homepage = http://synthv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
