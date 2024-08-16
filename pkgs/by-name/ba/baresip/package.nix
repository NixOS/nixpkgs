{
  SDL2,
  alsa-lib,
  cairo,
  celt,
  cmake,
  fetchFromGitHub,
  ffmpeg,
  glib,
  gsm,
  gst_all_1,
  gtk3,
  lib,
  libre,
  librem,
  libsndfile,
  libuuid,
  libv4l,
  libvpx,
  mpg123,
  openssl,
  pipewire,
  pkg-config,
  portaudio,
  spandsp3,
  speex,
  srtp,
  stdenv,
  zlib,
  dbusSupport ? true,
}:
stdenv.mkDerivation rec {
  version = "3.10.1";
  pname = "baresip";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "baresip";
    rev = "v${version}";
    hash = "sha256-0huZP1hopHaN5R1Hki6YutpvoASfIHzHMl/Y4czHHMo=";
  };
  prePatch = ''
    substituteInPlace cmake/FindGTK3.cmake --replace GTK3_CFLAGS_OTHER ""
  '' + lib.optionalString (!dbusSupport) ''
    substituteInPlace cmake/modules.cmake --replace 'list(APPEND MODULES ctrl_dbus)' ""
  '';
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    SDL2
    alsa-lib
    cairo
    celt
    ffmpeg
    gsm
    gtk3
    libre
    librem
    libsndfile
    libuuid
    libv4l
    libvpx
    mpg123
    openssl
    pipewire
    portaudio
    spandsp3
    speex
    srtp
    zlib
  ] ++ (with gst_all_1; [ gstreamer gst-libav gst-plugins-base gst-plugins-bad gst-plugins-good ]);

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-Dre_DIR=${libre}/include/re"
    "-DGL_INCLUDE_DIRS=${lib.getDev glib}/include/glib-2.0"
    "-DGLIB_INCLUDE_DIRS=${glib.out}/lib/glib-2.0/include"
    "-DGST_INCLUDE_DIRS=${lib.getDev gst_all_1.gstreamer}/include/gstreamer-1.0"
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CCACHE_DISABLE=1"
  ]
  ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}"
  ;

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = '' -I${librem}/include/rem -I${gsm}/include/gsm
    -DHAVE_INTTYPES_H -D__GLIBC__
    -D__need_timeval -D__need_timespec -D__need_time_t '';

  doInstallCheck = true;
  # CMake feature detection is prone to breakage between upgrades:
  # spot-check that the optional modules we care about were compiled
  postInstallCheck = lib.concatMapStringsSep "\n" (m: "test -x $out/lib/baresip/modules/${m}.so") [
    "account"
    "alsa"
    "aubridge"
    "auconv"
    "aufile"
    "auresamp"
    "ausine"
    "avcodec"
    "avfilter"
    "avformat"
    "cons"
    "contact"
    "ctrl_dbus"
    "ctrl_tcp"
    "debug_cmd"
    "dtls_srtp"
    "ebuacip"
    "echo"
    "evdev"
    "fakevideo"
    "g711"
    "g722"
    "g726"
    "gst"
    "gtk"
    "httpd"
    "httpreq"
    "ice"
    "l16"
    "menu"
    "mixausrc"
    "mixminus"
    "multicast"
    "mwi"
    "natpmp"
    "netroam"
    "pcp"
    "pipewire"
    "plc"
    "portaudio"
    "presence"
    "rtcpsummary"
    "sdl"
    "selfview"
    "serreg"
    "snapshot"
    "sndfile"
    "srtp"
    "stdio"
    "stun"
    "swscale"
    "syslog"
    "turn"
    "uuid"
    "v4l2"
    "vidbridge"
    "vidinfo"
    "vp8"
    "vp9"
    "vumeter"
    "x11"
  ];

  meta = {
    description = "Modular SIP User-Agent with audio and video support";
    homepage = "https://github.com/baresip/baresip";
    maintainers = with lib.maintainers; [ raskin ehmry ];
    mainProgram = "baresip";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
