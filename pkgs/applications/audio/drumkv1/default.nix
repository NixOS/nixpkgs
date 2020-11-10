{ mkDerivation, lib, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5 }:

mkDerivation rec {
  pname = "drumkv1";
  version = "0.9.18";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${pname}-${version}.tar.gz";
    sha256 = "1bzkaz7sqx1pvirja8zm7i2ckzl5ad6xspr4840389ik3l8qpnr5";
  };

  buildInputs = [ libjack2 alsaLib libsndfile liblo lv2 qt5.qtbase qt5.qttools ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with lib; {
    description = "An old-school drum-kit sampler synthesizer with stereo fx";
    homepage = "http://drumkv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
