{ stdenv, fetchurl, pkgconfig, gtk2, libsndfile, portaudio }:

stdenv.mkDerivation rec {
  name = "gnaural-1.0.20110606";
  buildInputs = [ pkgconfig gtk2 libsndfile portaudio ];
  src = fetchurl {
    url = "mirror://sourceforge/gnaural/Gnaural/${name}.tar.gz";
    sha256 = "0p9rasz1jmxf16vnpj17g3vzdjygcyz3l6nmbq6wr402l61f1vy5";
  };
  meta = with stdenv.lib;
    { description = "Auditory binaural-beat generator";
      homepage = http://gnaural.sourceforge.net/;
      license = licenses.gpl2;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
      broken = true;
    };
}
