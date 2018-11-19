{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5, fftw }:

stdenv.mkDerivation rec {
  name = "padthv1-${version}";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${name}.tar.gz";
    sha256 = "157w28wxggqpqkibz716v3r756q2z78g70ipncpalchb9dfr42b6";
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
