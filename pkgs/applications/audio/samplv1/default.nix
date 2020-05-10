{ stdenv, fetchurl, pkgconfig, libjack2, alsaLib, liblo, libsndfile, lv2, qt5 }:

stdenv.mkDerivation rec {
  pname = "samplv1";
  version = "0.9.14";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${pname}-${version}.tar.gz";
    sha256 = "0p3f9wsn1nz93szcl60yxhxdr554zm2z2jlbniwwify765lvasxc";
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
