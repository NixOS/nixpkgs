# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{ stdenv, fetchurl, alsaLib, bzip2, fftw, jackaudio, libX11, liblo,
libmad, libogg, librdf, librdf_raptor, librdf_rasqal, libsamplerate,
libsndfile, makeWrapper, pulseaudio, qt4, redland, rubberband, vampSDK
}:

stdenv.mkDerivation {
  name = "sonic-visualiser-1.8";

  src = fetchurl {
    url = http://downloads.sourceforge.net/sv1/sonic-visualiser-1.8.tar.gz;
    sha256 = "16ik6q9n92wljvnqcv7hyzb9v3yp3ixxp6df9kasf53fii973dh7";
  };

  buildInputs =
    [ libsndfile qt4 fftw /* should be fftw3f ??*/ bzip2 librdf rubberband
      libsamplerate vampSDK alsaLib librdf_raptor librdf_rasqal redland
      # optional
      jackaudio
      # portaudio
      pulseaudio
      libmad
      libogg # ?
      # fishsound
      liblo
      libX11
      makeWrapper
    ];

  buildPhase = ''
    for i in sonic-visualiser svapp svcore svgui; 
      do cd $i && qmake -makefile PREFIX=$out && cd ..;
    done
    make
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/sonic-visualiser}
    cp sonic-visualiser/sonic-visualiser $out/bin
    cp -r sonic-visualiser/samples $out/share/sonic-visualiser/samples
    wrapProgram $out/bin/sonic-visualiser --prefix LD_LIBRARY_PATH : ${libX11}/lib
  '';

  meta = { 
    description = "View and analyse contents of music audio files";
    homepage = http://www.sonicvisualiser.org/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber 
      stdenv.lib.maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
