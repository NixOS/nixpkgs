{
  lib,
  stdenv,
  mkDerivation,
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
  pcre,
  pkg-config,
  portaudio,
  portmidi,
  protobuf,
  qtbase,
  qtkeychain,
  qtscript,
  qtsvg,
  qtx11extras,
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
  wrapGAppsHook3,
}:

mkDerivation rec {
  pname = "mixxx";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = version;
    hash = "sha256-BOdXgA+z3sFE4ngAEhSbp1gDbsti1STJY2Yy6Hp+zTE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

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

  preFixup = ''
    qtWrapperArgs+=(--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive ''${gappsWrapperArgs[@]})
  '';

  # mixxx installs udev rules to DATADIR instead of SYSCONFDIR
  # let's disable this and install udev rules manually via postInstall
  # see https://github.com/mixxxdj/mixxx/blob/2.3.5/CMakeLists.txt#L1381-L1392
  cmakeFlags = [
    "-DINSTALL_USER_UDEV_RULES=OFF"
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

  meta = with lib; {
    homepage = "https://mixxx.org";
    description = "Digital DJ mixing software";
    mainProgram = "mixxx";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      bfortz
      benley
    ];
    platforms = platforms.linux;
  };
}
