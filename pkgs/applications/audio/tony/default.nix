{ stdenv, fetchurl, pkgconfig, wrapQtAppsHook
, alsaLib, boost, bzip2, fftw, fftwFloat, libX11, libfishsound, libid3tag
, libjack2, liblo, libmad, libogg, liboggz, libpulseaudio, libsamplerate
, libsndfile, lrdf, opusfile, qtbase, qtsvg, rubberband, serd, sord
}:

stdenv.mkDerivation rec {
  name = "tony-2.1.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2616/${name}.tar.gz";
    sha256 = "03g2bmlj08lmgvh54dyd635xccjn730g4wwlhpvsw04bffz8b7fp";
  };

  nativeBuildInputs = [ pkgconfig wrapQtAppsHook ];

  buildInputs = [
    alsaLib boost bzip2 fftw fftwFloat libX11 libfishsound libid3tag
    libjack2 liblo libmad libogg liboggz libpulseaudio libsamplerate
    libsndfile lrdf opusfile qtbase qtsvg rubberband serd sord
  ];

  # comment out the tests
  preConfigure = ''
    sed -i 's/sub_test_svcore_/#sub_test_svcore_/' tony.pro
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Pitch and note annotation of unaccompanied melody";
    homepage = https://www.sonicvisualiser.org/tony/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
