{ stdenv, fetchurl, qt4, pkgconfig, ladspaPlugins, ladspaH,
  dssi, liblo, liblrdf, fftwSinglePrec, libsndfile,
  libsamplerate, perl, makedepend, libjack2,
  withLirc ? false, lirc ? null } :

let rosegarden = rec {
  version = "14.12";
  base_name = "rosegarden";
  name = "${base_name}-${version}";
  url  = "mirror://sourceforge/rosegarden/${name}.tar.bz2";
  sha256 = "0zhlxr1njyy6837f09l6p75js0j5mxmls6m02bqafv9j32wgnxpq";

  homepage = http://www.rosegardenmusic.com/;
  description = "Rosegarden is a music composition and editing environment.";
  longDescription = ''
      Rosegarden is a music composition and editing environment based around a MIDI sequencer that features a rich understanding of music notation and includes basic support for digital audio.
      Rosegarden is an easy-to-learn, attractive application that runs on Linux, ideal for composers, musicians, music students, and small studio or home recording environments.
      '';
}; 

in stdenv.mkDerivation {
  inherit (rosegarden) name;
  src = fetchurl { inherit (rosegarden) url sha256; };

  QTDIR=qt4;
  
  buildInputs = [ qt4 pkgconfig ladspaPlugins ladspaH dssi liblo liblrdf fftwSinglePrec
                  libsndfile libsamplerate perl makedepend libjack2 ]
		++ stdenv.lib.optional withLirc [ lirc ];
  
  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    inherit (rosegarden) description longDescription version homepage;
    maintainers = [ maintainers.lebastr ];
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
