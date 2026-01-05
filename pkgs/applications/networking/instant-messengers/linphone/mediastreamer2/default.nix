{
  bctoolbox,
  bzrtp,
  ffmpeg_4,
  glew,
  gsm,
  lib,
  libX11,
  libXext,
  libopus,
  libpulseaudio,
  libsForQt5,
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
  ];

  nativeBuildInputs = [
    python3
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
  ];

  propagatedBuildInputs = [
    # Made by BC
    bctoolbox
    bzrtp
    ortp

    ffmpeg_4
    glew
    libX11
    libXext
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

  NIX_LDFLAGS = "-lXext";

  meta = {
    description = "Powerful and lightweight streaming engine specialized for voice/video telephony applications. Part of the Linphone project";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
})
