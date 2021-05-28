{ stdenv, fetchurl, cmake, makedepend, perl, pkgconfig, qttools, wrapQtAppsHook
, dssi, fftwSinglePrec, ladspaH, ladspaPlugins, libjack2, alsaLib
, liblo, libsamplerate, libsndfile, lirc ? null, lrdf, qtbase }:

stdenv.mkDerivation (rec {
  version = "20.06";
  pname = "rosegarden";

  src = fetchurl {
    url = "mirror://sourceforge/rosegarden/${pname}-${version}.tar.bz2";
    sha256 = "1i9x9rkqwwdrk77xl5ra8i48cjirbc7fbisnj0nnclccwaq0wk6r";
  };

  patchPhase = ''
    substituteInPlace src/CMakeLists.txt --replace svnheader svnversion
  '';

  nativeBuildInputs =
    [ cmake makedepend perl pkgconfig qttools wrapQtAppsHook ];

  buildInputs = [
    dssi
    fftwSinglePrec
    ladspaH
    ladspaPlugins
    libjack2
    liblo
    libsamplerate
    libsndfile
    lirc
    lrdf
    qtbase
    alsaLib
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://www.rosegardenmusic.com/";
    description = "Music composition and editing environment";
    longDescription = ''
      Rosegarden is a music composition and editing environment based around
      a MIDI sequencer that features a rich understanding of music notation
      and includes basic support for digital audio.

      Rosegarden is an easy-to-learn, attractive application that runs on Linux,
      ideal for composers, musicians, music students, and small studio or home
      recording environments.
    '';
    maintainers = with maintainers; [ lebastr ];
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
})
