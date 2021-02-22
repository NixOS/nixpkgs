{ lib, stdenv, fetchurl, zlib, openssl, libre, librem, pkg-config, gst_all_1
, cairo, mpg123, alsaLib, SDL, libv4l, celt, libsndfile, srtp, ffmpeg_3
, gsm, speex, portaudio, spandsp, libuuid, libvpx
}:
stdenv.mkDerivation rec {
  version = "0.6.5";
  pname = "baresip";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/baresip-${version}.tar.gz";
    sha256 = "13di0ycdcr2q2a20mjvyaqfmvk5xldwqaxklqsz7470jnbc5n0rb";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [zlib openssl libre librem cairo mpg123
    alsaLib SDL libv4l celt libsndfile srtp ffmpeg_3 gsm speex portaudio spandsp libuuid
    libvpx
  ] ++ (with gst_all_1; [ gstreamer gst-libav gst-plugins-base gst-plugins-bad gst-plugins-good ]);
  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_INC=${libre}/include/re"
    "LIBRE_SO=${libre}/lib"
    "LIBREM_PATH=${librem}"
    "PREFIX=$(out)"
    "USE_VIDEO=1"
    "CCACHE_DISABLE=1"

    "USE_ALSA=1" "USE_AMR=1" "USE_CAIRO=1" "USE_CELT=1"
    "USE_CONS=1" "USE_EVDEV=1" "USE_FFMPEG=1"  "USE_GSM=1" "USE_GST1=1"
    "USE_L16=1" "USE_MPG123=1" "USE_OSS=1" "USE_PLC=1" "USE_VPX=1"
    "USE_PORTAUDIO=1" "USE_SDL=1" "USE_SNDFILE=1" "USE_SPEEX=1"
    "USE_SPEEX_AEC=1" "USE_SPEEX_PP=1" "USE_SPEEX_RESAMP=1" "USE_SRTP=1"
    "USE_STDIO=1" "USE_SYSLOG=1" "USE_UUID=1" "USE_V4L2=1" "USE_X11=1"

    "USE_BV32=" "USE_COREAUDIO=" "USE_G711=1" "USE_G722=1" "USE_G722_1="
    "USE_ILBC=" "USE_OPUS=" "USE_SILK="
  ]
  ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}"
  ;

  NIX_CFLAGS_COMPILE='' -I${librem}/include/rem -I${gsm}/include/gsm
    -DHAVE_INTTYPES_H -D__GLIBC__
    -D__need_timeval -D__need_timespec -D__need_time_t '';
  meta = {
    homepage = "http://www.creytiv.com/baresip.html";
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.bsd3;
    inherit version;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/baresip-.*[.]tar[.].*";
  };
}
