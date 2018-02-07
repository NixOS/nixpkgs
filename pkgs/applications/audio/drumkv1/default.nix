{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5 }:

stdenv.mkDerivation rec {
  name = "drumkv1-${version}";
  version = "0.8.5";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${name}.tar.gz";
    sha256 = "06xqqm1ylmpp2s7xk7xav325gc50kxlvh9vf1343b0n3i8xkgjfg";
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
