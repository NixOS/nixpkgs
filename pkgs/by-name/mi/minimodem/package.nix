{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoconf,
  automake,
  libtool,
  fftwFloat,
  alsa-lib,
  libsndfile,
  libpulseaudio,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.24-1";
  pname = "minimodem";

  src = fetchFromGitHub {
    owner = "kamalmostafa";
    repo = "minimodem";
    tag = "minimodem-${finalAttrs.version}";
    hash = "sha256-FB++Rkk1ouUQMb713Q9z4uFKK+m3lRDu3Ocy6czwvaw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    libtool
    autoreconfHook
  ];
  buildInputs = [
    fftwFloat
    alsa-lib
    libsndfile
    libpulseaudio
  ];

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
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "minimodem";
  };
})
