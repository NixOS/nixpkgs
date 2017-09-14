{ stdenv, fetchurl, cmake, qt4, pkgconfig, ladspaPlugins, ladspaH,
  dssi, liblo, liblrdf, fftwSinglePrec, libsndfile,
  libsamplerate, perl, makedepend, libjack2,
  withLirc ? false, lirc ? null } :

stdenv.mkDerivation (rec {
  version = "17.04";
  name = "rosegarden-${version}";

  src = fetchurl {
    url  = "mirror://sourceforge/rosegarden/${name}.tar.bz2";
    sha256 = "1khfcj22asdhjh0jvhkqsz200wgmigkhsrcz09ffia5hqm0n32lq";
  };

  QTDIR = qt4;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake qt4 ladspaPlugins ladspaH dssi liblo liblrdf fftwSinglePrec
    libsndfile libsamplerate perl makedepend libjack2
  ] ++ stdenv.lib.optional withLirc [ lirc ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.rosegardenmusic.com/;
    description = "Music composition and editing environment";
    longDescription = ''
      Rosegarden is a music composition and editing environment based around a MIDI sequencer that features a rich understanding of music notation and includes basic support for digital audio.
      Rosegarden is an easy-to-learn, attractive application that runs on Linux, ideal for composers, musicians, music students, and small studio or home recording environments.
      '';

    maintainers = [ maintainers.lebastr ];
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
})
