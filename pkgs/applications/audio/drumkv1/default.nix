{ mkDerivation, lib, fetchurl, pkgconfig, libjack2, alsaLib, libsndfile, liblo, lv2, qt5 }:

mkDerivation rec {
  pname = "drumkv1";
  version = "0.9.16";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${pname}-${version}.tar.gz";
    sha256 = "1r55575w9r0ifysw9mgxjvv0fszvx8ykjgim3zczf3mb5s9ngavv";
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
