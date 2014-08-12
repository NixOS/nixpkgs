{ stdenv, fetchurl, jack2, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "drumkv1-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/drumkv1/${name}.tar.gz";
    sha256 = "16bjkp22hfpmzj5di98dddzslavgvhw5z7pgjzmjqz9dxvbqwq1k";
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