{ stdenv, fetchurl, jackaudio, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "samplv1-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${name}.tar.gz";
    sha256 = "1j6q3ywbdsyhskc60p7k8ph058ylrrmjmri3q1wr2d2akcaqvb7m";
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