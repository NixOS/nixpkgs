{ stdenv, fetchurl, jackaudio, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "samplv1-${version}";
  version = "0.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${name}.tar.gz";
    sha256 = "1fgy9w3mp0p8i1v41a7gmpzzk268k7bp75d4sgzfprikjihc6ary";
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