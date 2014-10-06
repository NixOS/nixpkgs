{ stdenv, fetchurl, jack2, libsndfile, lv2, qt4 }:

stdenv.mkDerivation rec {
  name = "samplv1-${version}";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/samplv1/${name}.tar.gz";
    sha256 = "155qq7gxyqn7sh8bbyhjk40lxl157lb2h539j4gqgv5jphz8g6wy";
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