# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{ lib, stdenv, fetchurl, alsa-lib, bzip2, fftw, libjack2, libX11, liblo
, libmad, lrdf, librdf_raptor, librdf_rasqal, libsamplerate
, libsndfile, pkg-config, libpulseaudio, qtbase, qtsvg, redland
, rubberband, serd, sord, vamp-plugin-sdk, fftwFloat
, capnproto, liboggz, libfishsound, libid3tag, opusfile
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sonic-visualiser";
  version = "4.2";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2755/${pname}-${version}.tar.gz";
    sha256 = "1wsvranhvdl21ksbinbgb55qvs3g2d4i57ssj1vx2aln6m01ms9q";
  };

  nativeBuildInputs = [ pkg-config wrapQtAppsHook ];
  buildInputs =
    [ libsndfile qtbase qtsvg fftw fftwFloat bzip2 lrdf rubberband
      libsamplerate vamp-plugin-sdk alsa-lib librdf_raptor librdf_rasqal redland
      serd
      sord
      # optional
      libjack2
      # portaudio
      libpulseaudio
      libmad
      libfishsound
      liblo
      libX11
      capnproto
      liboggz
      libid3tag
      opusfile
    ];

  # comment out the tests
  preConfigure = ''
    sed -i 's/sub_test_svcore_/#sub_test_svcore_/' sonic-visualiser.pro
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "View and analyse contents of music audio files";
    homepage = "https://www.sonicvisualiser.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
