{stdenv, fetchurl, zlib, openssl, libre, librem, pkgconfig
, cairo, mpg123, gstreamer, gst-ffmpeg, gst-plugins-base, gst-plugins-bad
, gst-plugins-good, alsaLib, SDL, libv4l, celt, libsndfile, srtp, ffmpeg
, gsm, speex, portaudio, spandsp, libuuid, ccache
}:
stdenv.mkDerivation rec {
  version = "0.5.1";
  name = "baresip-${version}";
  src=fetchurl {
    url = "http://www.creytiv.com/pub/baresip-${version}.tar.gz";
    sha256 = "0yi80gi2vb600n7wi6mk81zfdi1n5pg1dsz7458sb3z5cv5gj8yg";
  };
  buildInputs = [zlib openssl libre librem pkgconfig
    cairo mpg123 gstreamer gst-ffmpeg gst-plugins-base gst-plugins-bad gst-plugins-good
    alsaLib SDL libv4l celt libsndfile srtp ffmpeg gsm speex portaudio spandsp libuuid
    ccache
    ];
  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_INC=${libre}/include/re"
    "LIBRE_SO=${libre}/lib"
    "LIBREM_PATH=${librem}"
    ''PREFIX=$(out)''
    "USE_VIDEO=1"
    "CCACHE_DISABLE=1"

    "USE_ALSA=1" "USE_AMR=1" "USE_CAIRO=1" "USE_CELT=1" 
    "USE_CONS=1" "USE_EVDEV=1" "USE_FFMPEG=1"  "USE_GSM=1" "USE_GST=1" 
    "USE_L16=1" "USE_MPG123=1" "USE_OSS=1" "USE_PLC=1" 
    "USE_PORTAUDIO=1" "USE_SDL=1" "USE_SNDFILE=1" "USE_SPEEX=1" 
    "USE_SPEEX_AEC=1" "USE_SPEEX_PP=1" "USE_SPEEX_RESAMP=1" "USE_SRTP=1" 
    "USE_STDIO=1" "USE_SYSLOG=1" "USE_UUID=1" "USE_V4L2=1" "USE_X11=1"

    "USE_BV32=" "USE_COREAUDIO=" "USE_G711=1" "USE_G722=1" "USE_G722_1="
    "USE_ILBC=" "USE_OPUS=" "USE_SILK=" 
  ]
  ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}"
  ;
  NIX_CFLAGS_COMPILE='' -I${librem}/include/rem -I${gsm}/include/gsm
    -DHAVE_INTTYPES_H -D__GLIBC__ 
    -D__need_timeval -D__need_timespec -D__need_time_t '';
  meta = {
    homepage = "http://www.creytiv.com/baresip.html";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.bsd3;
    inherit version;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/baresip-.*[.]tar[.].*";
  };
}
