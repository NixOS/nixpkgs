{ stdenv, fetchurl, jack2, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "samplv1-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${name}.tar.gz";
    sha256 = "02mm5y1yzklvs5bpxl86y3dqcg7migfybmin8llk91pws6rl9b41";
  };

  buildInputs = [ jack2 libsndfile lv2 qt4 ];

  meta = with stdenv.lib; {
    description = "An old-school all-digital polyphonic sampler synthesizer with stereo fx";
    homepage = http://samplv1.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}