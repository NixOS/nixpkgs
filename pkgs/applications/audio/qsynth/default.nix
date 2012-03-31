{ stdenv, fetchurl, alsaLib, fluidsynth, jackaudio, qt4 }:

stdenv.mkDerivation  rec {
  name = "qsynth-${version}";
  version = "0.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${name}.tar.gz";
    sha256 = "0g7vaffpgs7v2p71ml5p7fzxz50mhlaklgf9zk4wbfk1hslqv5mm";
  };

  buildInputs = [ alsaLib fluidsynth jackaudio qt4 ];

  meta = with stdenv.lib; {
    description = "Fluidsynth GUI";
    homepage = http://sourceforge.net/projects/qsynth;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
  };
}
