{ stdenv, fetchurl, alsaLib, boost, bzip2, fftw, fftwFloat, libfishsound
, libid3tag, liblo, liblrdf, libmad, liboggz, libpulseaudio, libsamplerate
, libsndfile, opusfile, portaudio, rubberband, serd, sord, vampSDK, capnproto
, wrapQtAppsHook, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "sonic-lineup";
  version = "1.0.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2610/${pname}-${version}.tar.gz";
    sha256 = "0w4v5zr81d8fh97y820r0vj1rrbl0kwgvhfkdnyl4hiabs97b1i7";
  };

  buildInputs =
    [ alsaLib boost bzip2 fftw fftwFloat libfishsound libid3tag liblo liblrdf
      libmad liboggz libpulseaudio libsamplerate libsndfile opusfile pkgconfig
      portaudio rubberband serd sord capnproto
    ];

  nativeBuildInputs = [ pkgconfig wrapQtAppsHook ];

  enableParallelBuilding = true;

  # comment out the tests
  preConfigure = ''
    sed -i 's/sub_test_svcore_/#sub_test_svcore_/' sonic-lineup.pro
  '';

  meta = with stdenv.lib; {
    description = "Comparative visualisation of related audio recordings";
    homepage = https://www.sonicvisualiser.org/sonic-lineup/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vandenoever ];
    platforms = platforms.linux;
  };
}
