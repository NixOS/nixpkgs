{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5, fftw }:

stdenv.mkDerivation rec {
  name = "padthv1-${version}";
  version = "0.9.7";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${name}.tar.gz";
    sha256 = "1jd4bf6a1ipvg4yhb3xf3maqg68bx97ic9l57djmkirlrkh2a3wp";
  };

  buildInputs = [ libjack2 alsaLib libsndfile liblo lv2 qt5.qtbase qt5.qttools fftw ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "polyphonic additive synthesizer";
    homepage = http://padthv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
