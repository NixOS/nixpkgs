{ lib, stdenv, fetchurl, alsa-lib, boost, bzip2, fftw, fftwFloat, libfishsound
, libid3tag, liblo, libmad, liboggz, libpulseaudio, libsamplerate
, libsndfile, lrdf, opusfile, portaudio, rubberband, serd, sord, capnproto
, wrapQtAppsHook, pkg-config
, libjack2
}:

stdenv.mkDerivation rec {
  pname = "sonic-lineup";
  version = "1.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2765/${pname}-${version}.tar.gz";
    sha256 = "0k45k9fawcm4s5yy05x00pgww7j8m7k2cxcc7g0fn9vqy7vcbq9h";
  };

  buildInputs =
    [ alsa-lib boost bzip2 fftw fftwFloat libfishsound libid3tag liblo
      libmad liboggz libpulseaudio libsamplerate libsndfile lrdf opusfile
      portaudio rubberband serd sord capnproto
      libjack2
    ];

  nativeBuildInputs = [ pkg-config wrapQtAppsHook ];

  enableParallelBuilding = true;

  # comment out the tests
  preConfigure = ''
    sed -i 's/sub_test_svcore_/#sub_test_svcore_/' sonic-lineup.pro
  '';

  meta = with lib; {
    description = "Comparative visualisation of related audio recordings";
    homepage = "https://www.sonicvisualiser.org/sonic-lineup/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vandenoever ];
    platforms = platforms.linux;
    # undefined reference to `std::__throw_bad_array_new_length()@GLIBCXX_3.4.29'
    broken = true; # at 2022-09-30
  };
}
