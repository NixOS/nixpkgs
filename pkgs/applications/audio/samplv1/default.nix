{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, liblo, libsndfile, lv2, qt5 }:

stdenv.mkDerivation rec {
  pname = "samplv1";
  version = "0.9.13";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${pname}-${version}.tar.gz";
    sha256 = "0clsp6s5qfnh0xaxbd35vq2ppi72q9dfayrzlgl73800a8p7gh9m";
  };

  buildInputs = [ libjack2 alsaLib liblo libsndfile lv2 qt5.qtbase qt5.qttools];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "An old-school all-digital polyphonic sampler synthesizer with stereo fx";
    homepage = "http://samplv1.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
