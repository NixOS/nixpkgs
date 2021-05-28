{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5, fftwFloat, mkDerivation }:

mkDerivation rec {
  pname = "padthv1";
  version = "0.9.17";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${pname}-${version}.tar.gz";
    sha256 = "098fk8fwcgssnfr1gilqg8g17zvch62lrn3rqsswpzbr3an5adb3";
  };

  buildInputs = [ libjack2 alsaLib libsndfile liblo lv2 qt5.qtbase qt5.qttools fftwFloat ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "polyphonic additive synthesizer";
    homepage = "http://padthv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
