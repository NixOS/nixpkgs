{ lib, stdenv, fetchurl, fetchpatch2, pkg-config, wrapQtAppsHook
, alsa-lib, boost, bzip2, fftw, fftwFloat, libX11, libfishsound, libid3tag
, libjack2, liblo, libmad, libogg, liboggz, libpulseaudio, libsamplerate
, libsndfile, lrdf, opusfile, qtbase, qtsvg, rubberband, serd, sord
}:

stdenv.mkDerivation rec {
  pname = "tony";
  version = "2.1.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2616/${pname}-${version}.tar.gz";
    sha256 = "03g2bmlj08lmgvh54dyd635xccjn730g4wwlhpvsw04bffz8b7fp";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/sonic-visualiser/svcore/commit/5a7b517e43b7f0b3f03b7fc3145102cf4e5b0ffc.patch";
      stripLen = 1;
      extraPrefix = "svcore/";
      sha256 = "sha256-DOCdQqCihkR0g/6m90DbJxw00QTpyVmFzCxagrVWKiI=";
    })
    (fetchpatch2 {
      url = "https://github.com/sonic-visualiser/svgui/commit/5b6417891cff5cc614e8c96664d68674eb12b191.patch";
      stripLen = 1;
      extraPrefix = "svgui/";
      excludes = [ "svgui/widgets/CSVExportDialog.cpp" ];
      sha256 = "sha256-pBCtoMXgjreUm/D0pl6+R9x1Ovwwwj8Ohv994oMX8XA=";
    })
  ];

  nativeBuildInputs = [ pkg-config wrapQtAppsHook ];

  buildInputs = [
    alsa-lib boost bzip2 fftw fftwFloat libX11 libfishsound libid3tag
    libjack2 liblo libmad libogg liboggz libpulseaudio libsamplerate
    libsndfile lrdf opusfile qtbase qtsvg rubberband serd sord
  ];

  # comment out the tests
  preConfigure = ''
    sed -i 's/sub_test_svcore_/#sub_test_svcore_/' tony.pro
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Pitch and note annotation of unaccompanied melody";
    homepage = "https://www.sonicvisualiser.org/tony/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
