{ stdenv, fetchurl, pkgconfig, qt5, libjack2, alsaLib, liblo, lv2 }:

stdenv.mkDerivation rec {
  pname = "synthv1";
  version = "0.9.10";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${pname}-${version}.tar.gz";
    sha256 = "1ssdm7aiaz908ydqwdx9khxnnd0yfacjgvbxg5p9s9xhkbqqc2f2";
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
