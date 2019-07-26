{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5, fftw }:

stdenv.mkDerivation rec {
  name = "padthv1-${version}";
  version = "0.9.8";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${name}.tar.gz";
    sha256 = "1k4p2ir12qjcs62knvw2s6qyvb46203yx22fnwp341cjk171cxji";
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
