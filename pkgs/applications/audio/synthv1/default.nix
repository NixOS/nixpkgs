{ stdenv, fetchurl, pkgconfig, qt5, libjack2, alsaLib, liblo, lv2 }:

stdenv.mkDerivation rec {
  name = "synthv1-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/synthv1/${name}.tar.gz";
    sha256 = "1r60l286n8y4a4rrlnbc3h7xk4s2pvqykvskls89prxg0lkpz7kl";
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
