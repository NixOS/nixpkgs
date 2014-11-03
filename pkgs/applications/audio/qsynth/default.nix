{ stdenv, fetchurl, alsaLib, fluidsynth, jack2, qt4 }:

stdenv.mkDerivation  rec {
  name = "qsynth-${version}";
  version = "0.3.8";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${name}.tar.gz";
    sha256 = "0wmq61cq93x2l00xwr871373mj3dwamz1dg6v62x7s8m1612ndrw";
  };

  buildInputs = [ alsaLib fluidsynth jack2 qt4 ];

  meta = with stdenv.lib; {
    description = "Fluidsynth GUI";
    homepage = http://sourceforge.net/projects/qsynth;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
