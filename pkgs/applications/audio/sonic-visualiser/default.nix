# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{ stdenv, fetchurl, alsaLib, bzip2, fftw, libjack2, libX11, liblo
, libmad, libogg, librdf, librdf_raptor, librdf_rasqal, libsamplerate
, libsndfile, pkgconfig, libpulseaudio, qtbase, qtsvg, redland
, rubberband, serd, sord, vampSDK, fftwFloat
, capnproto, liboggz, libfishsound, libid3tag, opusfile
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sonic-visualiser";
  version = "4.0.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2607/${pname}-${version}.tar.gz";
    sha256 = "14674adzp3chilymna236qyvci3b1zmi3wyz696wk7bcd3ndpsg6";
  };

  buildInputs =
    [ libsndfile qtbase qtsvg fftw fftwFloat bzip2 librdf rubberband
      libsamplerate vampSDK alsaLib librdf_raptor librdf_rasqal redland
      serd
      sord
      # optional
      libjack2
      # portaudio
      libpulseaudio
      libmad
      libogg # ?
      libfishsound
      liblo
      libX11
      capnproto
      liboggz
      libid3tag
      opusfile
    ];

  nativeBuildInputs = [ pkgconfig wrapQtAppsHook ];

  enableParallelBuilding = true;

  # comment out the tests
  preConfigure = ''
    sed -i 's/sub_test_svcore_/#sub_test_svcore_/' sonic-visualiser.pro
  '';

  meta = with stdenv.lib; {
    description = "View and analyse contents of music audio files";
    homepage = https://www.sonicvisualiser.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
