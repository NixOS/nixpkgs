{ lib
, stdenv
, mkDerivation
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
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = version;
    hash = "sha256-VdgCsd/7vMFUleOU0ESoZDQ8yhQSsLZADVi4XI76Ouw=";
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

  qtWrapperArgs = [
    "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive"
  ];

  # mixxx installs udev rules to DATADIR instead of SYSCONFDIR
  # let's disable this and install udev rules manually via postInstall
  # see https://github.com/mixxxdj/mixxx/blob/2.3.5/CMakeLists.txt#L1381-L1392
  cmakeFlags = [
    "-DINSTALL_USER_UDEV_RULES=OFF"
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    rules="$src/res/linux/mixxx-usb-uaccess.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    mkdir -p "$out/lib/udev/rules.d"
    cp "$rules" "$out/lib/udev/rules.d/69-mixxx-usb-uaccess.rules"
  '';

  meta = with lib; {
    homepage = "https://mixxx.org";
    description = "Digital DJ mixing software";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu bfortz ];
    platforms = platforms.linux;
  };
}
