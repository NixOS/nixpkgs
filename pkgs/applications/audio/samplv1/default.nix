{ stdenv, fetchurl, libjack2, alsaLib, liblo, libsndfile, lv2, qt5 }:

stdenv.mkDerivation rec {
  name = "samplv1-${version}";
  version = "0.7.6";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${name}.tar.gz";
    sha256 = "071j7mi2cwhx0ml5hq8izmjb0s4yhbkscqaxfdg56xfpfsqsa63l";
  };

  buildInputs = [ libjack2 alsaLib liblo libsndfile lv2 qt5.qtbase qt5.qttools];

  meta = with stdenv.lib; {
    description = "An old-school all-digital polyphonic sampler synthesizer with stereo fx";
    homepage = http://samplv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
