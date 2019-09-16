{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5 }:

stdenv.mkDerivation rec {
  pname = "drumkv1";
  version = "0.9.9";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${pname}-${version}.tar.gz";
    sha256 = "02sa29fdjgwcf7izly685gxvga3bxyyqvskvfiisgm2xg3h9r983";
  };

  buildInputs = [ libjack2 alsaLib libsndfile liblo lv2 qt5.qtbase qt5.qttools ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "An old-school drum-kit sampler synthesizer with stereo fx";
    homepage = http://drumkv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
