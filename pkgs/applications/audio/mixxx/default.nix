{ lib
, mkDerivation
, fetchurl
, fetchFromGitHub
, chromaprint
, cmake
, faad2
, ffmpeg
, fftw
, flac
, glibcLocales
, hidapi
, lame
, libebur128
, libGLU
, libid3tag
, libkeyfinder
, libmad
, libmodplug
, libopus
, libsecret
, libshout
, libsndfile
, libusb1
, libvorbis
, libxcb
, lilv
, lv2
, mp4v2
, opusfile
, pcre
, pkg-config
, portaudio
, portmidi
, protobuf
, qtbase
, qtkeychain
, qtscript
, qtsvg
, qtx11extras
, rubberband
, serd
, sord
, soundtouch
, sratom
, sqlite
, taglib
, upower
, vamp-plugin-sdk
, wavpack
}:

mkDerivation rec {
  pname = "mixxx";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = version;
    sha256 = "18sx4l3zzbn5142xfv5bp0crdd615a5728fkprqacnx3zpa144x6";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    chromaprint
    faad2
    ffmpeg
    fftw
    flac
    glibcLocales
    hidapi
    lame
    libebur128
    libGLU
    libid3tag
    libkeyfinder
    libmad
    libmodplug
    libopus
    libsecret
    libshout
    libsndfile
    libusb1
    libvorbis
    libxcb
    lilv
    lv2
    mp4v2
    opusfile
    pcre
    portaudio
    portmidi
    protobuf
    qtbase
    qtkeychain
    qtscript
    qtsvg
    qtx11extras
    rubberband
    serd
    sord
    soundtouch
    sratom
    sqlite
    taglib
    upower
    vamp-plugin-sdk
    wavpack
  ];

  enableParallelBuilding = true;

  qtWrapperArgs = [
    "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive"
  ];

  meta = with lib; {
    homepage = "https://mixxx.org";
    description = "Digital DJ mixing software";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu bfortz ];
    platforms = platforms.linux;
  };
}
