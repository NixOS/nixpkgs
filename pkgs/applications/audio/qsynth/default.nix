{ stdenv, fetchurl, alsaLib, fluidsynth, libjack2, qt4 }:

stdenv.mkDerivation  rec {
  name = "qsynth-${version}";
  version = "0.3.9";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${name}.tar.gz";
    sha256 = "08kyn6cl755l9i1grzjx8yi3f8mgiz4gx0hgqad1n0d8yz85087b";
  };

  buildInputs = [ alsaLib fluidsynth libjack2 qt4 ];

  meta = with stdenv.lib; {
    description = "Fluidsynth GUI";
    homepage = https://sourceforge.net/projects/qsynth;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
