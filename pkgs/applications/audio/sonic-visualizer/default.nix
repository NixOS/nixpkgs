# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

args: with args;

stdenv.mkDerivation {

#TODO add plugins!

  name = "sonic-visualizer-1.6";

  src = fetchurl {
    url = http://downloads.sourceforge.net/sv1/sonic-visualiser-1.6.tar.bz2;
    sha256 = "1dbqqa7anii2jnjpfwm4sr83nn4bwmz68xw4n6clycsz5iqk52f5";
  };

  buildInputs = [libsndfile qt fftw /* should be fftw3f ??*/ bzip2 librdf rubberband
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

  buildPhase = ''
    qmake -makefile PREFIX=$out && make
  '';

  installPhase = ''
    ensureDir $out/{bin,share/sv}
    cp sv/sonic-visualiser $out/bin
    cp -r sv/samples $out/share/sv/samples
  '';

  meta = { 
    description = "View and analyse contents of music audio files";
    homepage = http://www.sonicvisualiser.org/;
    license = "GPLv2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
