# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{ stdenv, fetchurl, alsaLib, bzip2, fftw, jackaudio, libX11, liblo
, libmad, libogg, librdf, librdf_raptor, librdf_rasqal, libsamplerate
, libsndfile, pkgconfig, pulseaudio, qt5, redland
, rubberband, serd, sord, vampSDK
}:

stdenv.mkDerivation rec {
  name = "sonic-visualiser-${version}";
  version = "2.3";

  src = fetchurl {

    url = "http://code.soundsoftware.ac.uk/attachments/download/918/${name}.tar.gz";
    sha256 = "1f06w2rin4r2mbi00bg3nmqdi2xdy9vq4jcmfanxzj3ld66ik40c";
  };

  buildInputs =
    [ libsndfile qt5 fftw /* should be fftw3f ??*/ bzip2 librdf rubberband
      libsamplerate vampSDK alsaLib librdf_raptor librdf_rasqal redland
      serd
      sord
      pkgconfig
      # optional
      jackaudio
      # portaudio
      pulseaudio
      libmad
      libogg # ?
      # fishsound
      liblo
      libX11
    ];

  buildPhase = ''
    for i in sonic-visualiser svapp svcore svgui;
      do cd $i && qmake -makefile PREFIX=$out && cd ..;
    done
    make
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/sonic-visualiser}
    cp sonic-visualiser $out/bin/
    cp -r samples $out/share/sonic-visualiser/
  '';

  meta = with stdenv.lib; {
    description = "View and analyse contents of music audio files";
    homepage = http://www.sonicvisualiser.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
