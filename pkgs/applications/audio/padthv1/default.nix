{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5, fftw }:

stdenv.mkDerivation rec {
  name = "padthv1-${version}";
  version = "0.8.5";

  src = fetchurl {
    url = "mirror://sourceforge/padthv1/${name}.tar.gz";
    sha256 = "0dyrllxgd74nknixjcz6n7m4gw70v246s8z1qss7zfl5yllhb712";
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
