{
  lib,
  stdenv,
  fetchFromGitHub,
  chromaprint,
  cmake,
  faad2,
  ffmpeg,
  fftw,
  flac,
  gbenchmark,
  glibcLocales,
  gtest,
  hidapi,
  lame,
  libebur128,
  libdjinterop,
  libGLU,
  libid3tag,
  libkeyfinder,
  libmad,
  libmodplug,
  libopus,
  libsecret,
  libshout,
  libsndfile,
  libusb1,
  libvorbis,
  libxcb,
  lilv,
  lv2,
  microsoft-gsl,
  mp4v2,
  opusfile,
  pkg-config,
  portaudio,
  portmidi,
  protobuf,
  rubberband,
  serd,
  sord,
  soundtouch,
  sratom,
  sqlite,
  taglib,
  upower,
  vamp-plugin-sdk,
  wavpack,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "mixxx";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = version;
    hash = "sha256-WmYoblIVygLnjNaFnRoEHmfnQcaBtIVOBZicEwD4NMw=";
  };

  # Should be removed when bumping to 2.6.x
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn "LIBDJINTEROP_VERSION 0.24.3" "LIBDJINTEROP_VERSION 0.26.1"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    chromaprint
    faad2
    ffmpeg
    fftw
    flac
    gbenchmark
    glibcLocales
    gtest
    hidapi
    lame
    libebur128
    libGLU
    libid3tag
    libdjinterop
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
    microsoft-gsl
    mp4v2
    opusfile
    portaudio
    portmidi
    protobuf
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtkeychain
    kdePackages.qtsvg
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

  qtWrapperArgs = [ "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive" ];

  # mixxx installs udev rules to DATADIR instead of SYSCONFDIR
  # let's disable this and install udev rules manually via postInstall
  # see https://github.com/mixxxdj/mixxx/blob/2.3.5/CMakeLists.txt#L1381-L1392
  cmakeFlags = [
    "-DINSTALL_USER_UDEV_RULES=OFF"
    # "BUILD_TESTING=OFF" must imply "BUILD_BENCH=OFF"
    "-DBUILD_BENCH=OFF"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    rules="$src/res/linux/mixxx-usb-uaccess.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    mkdir -p "$out/lib/udev/rules.d"
    cp "$rules" "$out/lib/udev/rules.d/69-mixxx-usb-uaccess.rules"
  '';

  meta = {
    homepage = "https://mixxx.org";
    description = "Digital DJ mixing software";
    mainProgram = "mixxx";
    changelog = "https://github.com/mixxxdj/mixxx/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      benley
      bfortz
    ];
    platforms = lib.platforms.linux;
  };
}
