{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoconf,
  automake,
  libtool,
  libsndfile,
  libpulseaudio,
  espeak-ng,
  sonic,
  utf8cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ekho";
  version = "9.0";

  src = fetchFromGitHub {
    owner = "hgneng";
    repo = "ekho";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VYN9tR3BJXd3UA0V5vqQJNItJe1e1knZ+S7tLeaeYYk=";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  CXXFLAGS = [
    "-O0"
    "-I${lib.getDev utf8cpp}/include/utf8cpp"
  ];

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    libsndfile
    libpulseaudio
    espeak-ng
    sonic
    utf8cpp
  ];

  meta = {
    description = "Chinese text-to-speech software";
    homepage = "http://www.eguidedog.net/ekho.php";
    longDescription = ''
      Ekho (余音) is a free, open source and multilingual text-to-speech (TTS)
      software. It supports Cantonese (Chinese dialect spoken in Hong Kong and
      part of Guangdong province), Mandarin (standard Chinese), Zhaoan Hakka
      (a dialect in Taiwan), Tibetan, Ngangien (an ancient Chinese before
      Yuan Dynasty) and Korean (in trial).
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "ekho";
  };
})
