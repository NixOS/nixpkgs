# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{ stdenv, fetchurl, alsaLib, bzip2, fftw, jackaudio, libX11, liblo,
libmad, libogg, librdf, librdf_raptor, librdf_rasqal, libsamplerate,
libsndfile, makeWrapper, pkgconfig, pulseaudio, qt4, redland, rubberband, vampSDK
}:

stdenv.mkDerivation rec {
  name = "sonic-visualiser-${version}";
  version = "1.9";

  src = fetchurl {
    url = "http://code.soundsoftware.ac.uk/attachments/download/194/${name}.tar.gz";
    sha256 = "00igf7j6s8xfyxnlkbqma0yby9pknxqzy8cmh0aw95ix80cw56fq";
  };

  buildInputs =
    [ libsndfile qt4 fftw /* should be fftw3f ??*/ bzip2 librdf rubberband
      libsamplerate vampSDK alsaLib librdf_raptor librdf_rasqal redland
      # optional
      jackaudio
      pkgconfig
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
