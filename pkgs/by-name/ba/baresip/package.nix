{ lib
, stdenv
, fetchFromGitHub
, zlib
, openssl
, libre
, librem
, pkg-config
, gst_all_1
, cairo
, gtk3
, mpg123
, alsa-lib
, SDL2
, libv4l
, celt
, libsndfile
, srtp
, ffmpeg
, gsm
, speex
, portaudio
, spandsp3
, libuuid
, libvpx
, cmake
, dbusSupport ? true
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
  prePatch = lib.optionalString (!dbusSupport) ''
    substituteInPlace cmake/modules.cmake --replace 'list(APPEND MODULES ctrl_dbus)' ""
  '';
  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    zlib
    openssl
    libre
    librem
    cairo
    gtk3
    mpg123
    alsa-lib
    SDL2
    libv4l
    celt
    libsndfile
    srtp
    ffmpeg
    gsm
    speex
    portaudio
    spandsp3
    libuuid
    libvpx
  ] ++ (with gst_all_1; [ gstreamer gst-libav gst-plugins-base gst-plugins-bad gst-plugins-good ]);

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-Dre_DIR=${libre}/include/re"
  ];

  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_SO=${libre}/lib"
    "LIBREM_PATH=${librem}"
    "PREFIX=$(out)"
    "USE_VIDEO=1"
    "CCACHE_DISABLE=1"

    "USE_ALSA=1"
    "USE_AMR=1"
    "USE_CAIRO=1"
    "USE_CELT=1"
    "USE_CONS=1"
    "USE_EVDEV=1"
    "USE_FFMPEG=1"
    "USE_GSM=1"
    "USE_GST1=1"
    "USE_GTK=1"
    "USE_L16=1"
    "USE_MPG123=1"
    "USE_OSS=1"
    "USE_PLC=1"
    "USE_VPX=1"
    "USE_PORTAUDIO=1"
    "USE_SDL=1"
    "USE_SNDFILE=1"
    "USE_SPEEX=1"
    "USE_SPEEX_AEC=1"
    "USE_SPEEX_PP=1"
    "USE_SPEEX_RESAMP=1"
    "USE_SRTP=1"
    "USE_STDIO=1"
    "USE_SYSLOG=1"
    "USE_UUID=1"
    "USE_V4L2=1"
    "USE_X11=1"

    "USE_BV32="
    "USE_COREAUDIO="
    "USE_G711=1"
    "USE_G722=1"
    "USE_G722_1="
    "USE_ILBC="
    "USE_OPUS="
    "USE_SILK="
  ]
  ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}"
  ;

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = '' -I${librem}/include/rem -I${gsm}/include/gsm
    -DHAVE_INTTYPES_H -D__GLIBC__
    -D__need_timeval -D__need_timespec -D__need_time_t '';

  meta = {
    description = "A modular SIP User-Agent with audio and video support";
    homepage = "https://github.com/baresip/baresip";
    maintainers = with lib.maintainers; [ elohmeier raskin ehmry ];
    mainProgram = "baresip";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
