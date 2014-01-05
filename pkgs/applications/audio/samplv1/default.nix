{ stdenv, fetchurl, jackaudio, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "samplv1-${version}";
  version = "0.3.5";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${name}.tar.gz";
    sha256 = "1q4ggcbbz9lfrjh0ybr3grgipjkq6w5fb9gz5k5cryzz92p7ihw9";
  };

  buildInputs = [ jackaudio libsndfile lv2 qt4 ];

  meta = with stdenv.lib; {
    description = "An old-school all-digital polyphonic sampler synthesizer with stereo fx";
    homepage = http://samplv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}