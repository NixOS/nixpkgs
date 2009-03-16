args: with args;
let inherit (args.composableDerivation) composableDerivation edf; in
composableDerivation {} {

    name = "sox-14.0.0";

    src = args.fetchurl {
      url = mirror://sourceforge/sox/sox-14.0.0.tar.gz;
      sha256 = "1l7v04nlvb96y0w9crvm6nq8g50yxp3bkv6nb1c205s982inlalc";
    };

    flags =
    # are these options of interest? We'll see
    #--disable-fftw          disable usage of FFTW
    #--enable-debug          enable debugging
    #--disable-cpu-clip      disable tricky cpu specific clipper
    edf { name = "alsa"; enable = { buildInputs = [alsaLib]; }; }
    // edf { name = "libao"; enable = { buildInputs = [libao]; }; }
    // edf { name = "oss"; }
    // edf { name = "sun_audio"; };
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
  };


  optionals = [ "libsndfile" "libogg" "flac" "ffmpeg" "libmad" "lame"
                 /* "amr-wb" "amr-nb" */
                "libsamplerate" /* "ladspa" */ ];


  meta = {
    description = "Sample Rate Converter for audio";
    homepage = http://www.mega-nerd.com/SRC/index.html;
    # you can choose one of the following licenses:
    license = [ "GPL"
                { url=http://www.mega-nerd.com/SRC/libsamplerate-cul.pdf;
                  name="libsamplerate Commercial Use License";
                } ];
  };
}
