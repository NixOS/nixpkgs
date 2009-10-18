args: with args;
let inherit (args.composableDerivation) composableDerivation edf; in
composableDerivation {} {

    name = "sox-14.3.0";

    src = args.fetchurl {
      url = mirror://sourceforge/sox/sox-14.3.0.tar.gz;
      sha256 = "15r39dq9nlwrypm0vpxmbxyqqv0bd6284djbi1fdfrlkjhf43gws";
    };

    flags =
    # are these options of interest? We'll see
    #--disable-fftw          disable usage of FFTW
    #--enable-debug          enable debugging
    #--disable-cpu-clip      disable tricky cpu specific clipper
    edf { name = "alsa"; enable = { buildInputs = [alsaLib]; }; }
    // edf { name = "libao"; enable = { buildInputs = [libao]; }; }
    // edf { name = "oss"; }
    // edf { name = "sun_audio"; }
    // edf { name = "dl-lame"; enable.buildInputs = [ lame ]; } # use shared library
    // edf { name = "lame";    enable.buildInputs = [ lame ]; }
    // edf { name = "dl-mad"; enable.buildInputs = [ libmad ]; } # use shared library
    // edf { name = "mad";    enable.buildInputs =[ libmad ]; }
    ;
    # These options should be autodetected by the configure script
    /*
    --without-sndfile       Don't try to use libsndfile
    --without-ogg           Don't try to use Ogg Vorbis
    --without-flac          Don't try to use FLAC
    --without-ffmpeg        Don't try to use ffmpeg
    --without-mad           Don't try to use MAD (MP3 Audio Decoder)
    --without-lame          Don't try to use LAME (LAME Ain't an MP3 Encoder)
    --without-amr-wb        Don't try to use amr-wb
    --without-amr-nb        Don't try to use amr-nb
    --without-samplerate    Don't try to use libsamplerate (aka Secret Rabbit
                            Code)
    --without-ladspa        Don't try to use LADSPA
    --with-ladspa-path      Default search path for LADSPA plugins
    */


  cfg = {
    ossSupport = false;
    sun_audioSupport = false;
  } // lib.listToAttrs [
      { name = "dl-lameSupport"; value = true; }
      { name = "dl-madSupport"; value = true; }
  ];

  configureFlags = ["-enable-dl-lame"];


  optionals = [ "libsndfile" "libogg" "flac" "ffmpeg" "libmad" "lame"
                 /* "amr-wb" "amr-nb" */
                "libsamplerate" /* "ladspa" */ ];


  meta = {
    description = "Sample Rate Converter for audio";
    homepage = http://www.mega-nerd.com/SRC/index.html;
    maintainers = [lib.maintainers.marcweber];
    # you can choose one of the following licenses:
    license = [
      "GPL"
      # http://www.mega-nerd.com/SRC/libsamplerate-cul.pdf
      "libsamplerate Commercial Use License"
    ];
  };
}
