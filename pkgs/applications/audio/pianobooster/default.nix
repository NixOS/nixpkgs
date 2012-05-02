{ stdenv, fetchurl, alsaLib, cmake, qt4 }:

stdenv.mkDerivation  rec {
  name = "pianobooster-${version}";
  version = "0.6.4b";

  src = fetchurl {
    url = "mirror://sourceforge/pianobooster/pianobooster-src-0.6.4b.tar.gz";
    sha256 = "1xwyap0288xcl0ihjv52vv4ijsjl0yq67scc509aia4plmlm6l35";
  };

  preConfigure = "cd src";

  buildInputs = [ alsaLib cmake qt4 ];

  meta = with stdenv.lib; {
    description = "A MIDI file player that teaches you how to play the piano";
    homepage = http://pianobooster.sourceforge.net;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
  };
}
