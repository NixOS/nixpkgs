{ stdenv, fetchurl, libjack2, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "drumkv1-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${name}.tar.gz";
    sha256 = "1fbi835559qsg9fxgdbdyf5z1zlzf9n8zrq0p67damb55mmigaj8";
  };

  buildInputs = [ libjack2 libsndfile lv2 qt4 ];

  meta = with stdenv.lib; {
    description = "An old-school drum-kit sampler synthesizer with stereo fx";
    homepage = http://drumkv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
