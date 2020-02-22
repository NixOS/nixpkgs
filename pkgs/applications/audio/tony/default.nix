{ stdenv, fetchurl, alsaLib, boost, bzip2, fftw, fftwFloat, libfishsound
, libid3tag, liblo, liblrdf, libmad, liboggz, libpulseaudio, libsamplerate
, libsndfile, opusfile, portaudio, rubberband, serd, sord, vampSDK
, wrapQtAppsHook, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "tony";
  version = "2.1.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2616/${pname}-${version}.tar.gz";
    sha256 = "03g2bmlj08lmgvh54dyd635xccjn730g4wwlhpvsw04bffz8b7fp";
  };

  buildInputs =
    [ alsaLib boost bzip2 fftw fftwFloat libfishsound libid3tag liblo liblrdf
      libmad liboggz libpulseaudio libsamplerate libsndfile opusfile pkgconfig
      portaudio rubberband serd sord
    ];

  nativeBuildInputs = [ pkgconfig wrapQtAppsHook ];

  enableParallelBuilding = true;

  # comment out the tests
  preConfigure = ''
    sed -i 's/sub_test_svcore_/#sub_test_svcore_/' tony.pro
  '';

  meta = with stdenv.lib; {
    description = "High quality melody transcription";
    homepage = https://www.sonicvisualiser.org/tony/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vandenoever ];
    platforms = platforms.linux;
  };
}
