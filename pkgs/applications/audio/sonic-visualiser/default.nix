# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{ stdenv, fetchurl, alsaLib, bzip2, fftw, libjack2, libX11, liblo
, libmad, libogg, librdf, librdf_raptor, librdf_rasqal, libsamplerate
, libsndfile, pkgconfig, libpulseaudio, qtbase, redland
, qmake, rubberband, serd, sord, vampSDK, fftwFloat
}:

stdenv.mkDerivation rec {
  pname = "sonic-visualiser";
  version = "2.4.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/1185/${pname}-${version}.tar.gz";
    sha256 = "06nlha70kgrby16nyhngrv5q846xagnxdinv608v7ga7vpywwmyb";
  };

  buildInputs =
    [ libsndfile qtbase fftw fftwFloat bzip2 librdf rubberband
      libsamplerate vampSDK alsaLib librdf_raptor librdf_rasqal redland
      serd
      sord
      # optional
      libjack2
      # portaudio
      libpulseaudio
      libmad
      libogg # ?
      # fishsound
      liblo
      libX11
    ];

  nativeBuildInputs = [ pkgconfig qmake ];

  configurePhase = ''
    for i in sonic-visualiser svapp svcore svgui;
      do cd $i && qmake PREFIX=$out && cd ..;
    done
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/sonic-visualiser}
    cp sonic-visualiser $out/bin/
    cp -r samples $out/share/sonic-visualiser/
  '';

  meta = with stdenv.lib; {
    description = "View and analyse contents of music audio files";
    homepage = https://www.sonicvisualiser.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
    broken = true;
  };
}
