{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5, fftw, mkDerivation }:

mkDerivation rec {
  pname = "padthv1";
  version = "0.9.12";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${pname}-${version}.tar.gz";
    sha256 = "1zz3rz990k819q0rlzllqdwvag0x9k63443lb0mp8lwlczxnza6l";
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
