{ mkDerivation, lib, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5 }:

mkDerivation rec {
  pname = "drumkv1";
  version = "0.9.14";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${pname}-${version}.tar.gz";
    sha256 = "0fr7pkp55zvjxf7p22drs93fsjgvqhbd55vxi0srhp2s2wzz5qak";
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
