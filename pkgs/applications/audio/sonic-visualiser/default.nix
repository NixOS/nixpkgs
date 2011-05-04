# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{ stdenv, fetchurl, alsaLib, bzip2, fftw, jackaudio, libX11, liblo,
libmad, libogg, librdf, librdf_raptor, librdf_rasqal, libsamplerate,
libsndfile, makeWrapper, pulseaudio, qt, redland, rubberband, vampSDK
}:

stdenv.mkDerivation {
  name = "sonic-visualiser-1.8";

  src = fetchurl {
    url = http://downloads.sourceforge.net/sv1/sonic-visualiser-1.8.tar.gz;
    sha256 = "16ik6q9n92wljvnqcv7hyzb9v3yp3ixxp6df9kasf53fii973dh7";
  };

  buildInputs =
    [ libsndfile qt fftw /* should be fftw3f ??*/ bzip2 librdf rubberband
      libsamplerate vampSDK alsaLib librdf_raptor librdf_rasqal redland
      # optional
      jackaudio
      # portaudio
      pulseaudio
      libmad
      libogg # ?
      # fishsound
      liblo
    ];

  # TODO: Check if this is necessary
  buildPhase = ''
    for i in sonic-visualiser svapp svcore svgui; 
      do cd $i && qmake -makefile PREFIX=$out && cd ..;
    done
    make
  '';

  installPhase = ''
    ensureDir $out/{bin,share/sonic-visualiser}
    cp sonic-visualiser/sonic-visualiser $out/bin
    cp -r sonic-visualiser/samples $out/share/sonic-visualiser/samples
  '';

  # TODO: Fix this, it is not getting called
  postInstall = ''
    wrapProgram $out/bin/sonic-visualiser --prefix LD_LIBRARY_PATH : ${libX11}/lib
  '';

  meta = { 
    description = "View and analyse contents of music audio files";
    homepage = http://www.sonicvisualiser.org/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
