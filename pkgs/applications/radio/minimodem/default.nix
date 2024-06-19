{ lib, stdenv, fetchFromGitHub, pkg-config, autoconf, automake, libtool
, fftw, fftwSinglePrec, alsa-lib, libsndfile, libpulseaudio
}:

stdenv.mkDerivation rec {
  version = "0.24-1";
  pname = "minimodem";

  src = fetchFromGitHub {
    owner = "kamalmostafa";
    repo = "minimodem";
    rev = "${pname}-${version}";
    sha256 = "1b5xy36fjcp7vkp115dpx4mlmqg2fc7xvxdy648fb8im953bw7ql";
  };

  nativeBuildInputs = [ pkg-config autoconf automake libtool ];
  buildInputs = [ fftw fftwSinglePrec alsa-lib libsndfile libpulseaudio ];

  preConfigure = ''
    aclocal \
    && autoheader \
    && automake --gnu --add-missing \
    && autoconf
  '';

  meta = {
    description = "General-purpose software audio FSK modem";
    longDescription = ''
    Minimodem is a command-line program which decodes (or generates) audio
    modem tones at any specified baud rate, using various framing protocols. It
    acts a general-purpose software FSK modem, and includes support for various
    standard FSK protocols such as Bell103, Bell202, RTTY, NOAA SAME, and
    Caller-ID.
    '';
    homepage = "http://www.whence.com/minimodem/";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ relrod ];
    mainProgram = "minimodem";
  };
}

