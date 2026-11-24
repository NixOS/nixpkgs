{
  bctoolbox,
  bzrtp,
  fetchpatch,
  ffmpeg,
  glew,
  gsm,
  lib,
  libsm,
  libx11,
  libxext,
  libopus,
  libpulseaudio,
  qt6Packages,
  libv4l,
  libvpx,
  mkLinphoneDerivation,
  ortp,
  python3,
  speex,
  sqlite,
  srtp,
}:
mkLinphoneDerivation (finalAttrs: {
  pname = "mediastreamer2";

  dontWrapQtApps = true;

  patches = [
    # Plugins directory is normally fixed during compile time. This patch makes
    # it possible to set the plugins directory run time with an environment
    # variable MEDIASTREAMER_PLUGINS_DIR. This makes it possible to construct a
    # plugin directory with desired plugins and wrap executables so that the
    # environment variable points to that directory.
    ./plugins_dir.patch

    # Port to the FFmpeg 5+ API, from OpenMandriva
    (fetchpatch {
      url = "https://raw.githubusercontent.com/OpenMandrivaAssociation/mediastreamer/ccb74d4e23946ed0e63a4409c5524165a51eabb8/mediastreamer2-5.0.66-ffmpeg-6.0.patch";
      hash = "sha256-/2dijreltg9WDtzXpnH1T+xRVgDPWHGO3j2OzzxKek8=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/OpenMandrivaAssociation/mediastreamer/ccb74d4e23946ed0e63a4409c5524165a51eabb8/mediastreamer2-5.4.106-ffmpeg-8.patch";
      hash = "sha256-PicfYfwAxN78afHB2HzbOm45O/6zPU2jkhdaL67+axA=";
    })
    # Fix the FFmpeg port's decoder: allocate the AVCodecContext (an embedded one
    # has no defaults and crashes on a NULL get_format) and set the MPEG-4
    # config as extradata before opening the codec (FFmpeg ignores it after)
    ./ffmpeg-decoder-alloc-context.patch
  ];

  nativeBuildInputs = [
    python3
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
  ];

  propagatedBuildInputs = [
    # Made by BC
    bctoolbox
    bzrtp
    ortp

    ffmpeg
    glew
    libsm
    libx11
    libxext
    libpulseaudio
    libv4l
    speex
    srtp
    sqlite

    # Optional
    gsm # GSM audio codec
    libopus # Opus audio codec
    libvpx # VP8 video codec
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DENABLE_QT_GL=ON" # Build necessary MSQOGL plugin for Linphone desktop
    "-DCMAKE_C_FLAGS=-DGIT_VERSION=\"v${finalAttrs.version}\""
    "-DENABLE_STRICT=NO" # Disable -Werror
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  env.NIX_LDFLAGS = "-lXext";

  meta = {
    description = "Powerful and lightweight streaming engine specialized for voice/video telephony applications. Part of the Linphone project";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
})
