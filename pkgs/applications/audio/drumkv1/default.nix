{ stdenv, fetchurl, jack2, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "drumkv1-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${name}.tar.gz";
    sha256 = "1y3imsh059y9sihr92f3drwmcby4x3krmhly111ahwkydb94kphw";
  };

  buildInputs = [ jack2 libsndfile lv2 qt4 ];

  meta = with stdenv.lib; {
    description = "An old-school drum-kit sampler synthesizer with stereo fx";
    homepage = http://drumkv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}