{ stdenv, fetchurl, pkgconfig
, alsaLib, cairo, celt, ffmpeg, gsm, gst_ffmpeg, gst_plugins_bad
, gst_plugins_base, gst_plugins_good, gstreamer, libopus, libre, librem
, libsndfile, libuuid, libv4l, mpg123, openssl, portaudio, SDL, spandsp
, speex, srtp, zlib
}:

stdenv.mkDerivation rec {
  name = "baresip-0.4.12";

  src=fetchurl {
    url = "http://www.creytiv.com/pub/${name}.tar.gz";
    sha256 = "0f4jfpyvlgvq47yha3ys3kbrpd6c20yxaqki70hl6b91jbhmq9i2";
  };

  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_INC=${libre}/include/re"
    "LIBRE_SO=${libre}/lib"
    "LIBREM_PATH=${librem}"
    "PREFIX=$(out)"
    "USE_VIDEO=1"

    "USE_ALSA=1"
    "USE_AMR=1"
    "USE_AVCAPTURE="
    "USE_AVCODEC=1"
    "USE_AVFORMAT=1"
    "USE_BV32="
    "USE_CAIRO=1"
    "USE_CELT=1"
    "USE_CONS=1"
    "USE_COREAUDIO="
    "USE_EVDEV=1"
    "USE_G711="
    "USE_G722="
    "USE_G722_1="
    "USE_G726="
    "USE_GSM=1"
    "USE_GST=1"
    "USE_ILBC="
    "USE_ISAC="
    "USE_L16=1"
    "USE_LIBSRTP="
    "USE_MPG123=1"
    "USE_OPUS=1"
    "USE_OSS="
    "USE_PLC=1"
    "USE_PORTAUDIO=1"
    "USE_SDL=1"
    "USE_SILK="
    "USE_SNDFILE=1"
    "USE_SPEEX=1"
    "USE_SPEEX_AEC=1"
    "USE_SPEEX_PP=1"
    "USE_SPEEX_RESAMP=1"
    "USE_SRTP=1"
    "USE_STDIO=1"
    "USE_SYSLOG=1"
    "USE_UUID=1"
    "USE_V4L="
    "USE_V4L2=1"
    "USE_WINWAVE="
    "USE_X11=1"
  ] ++ stdenv.lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
    ++ stdenv.lib.optional (stdenv.cc.libc != null) "SYSROOT=${stdenv.cc.libc}";

  NIX_CFLAGS_COMPILE='' -I${librem}/include/rem -I${gsm}/include/gsm '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    alsaLib cairo celt ffmpeg gsm gst_ffmpeg gst_plugins_bad gst_plugins_base
    gst_plugins_good gstreamer libopus libre librem libsndfile libuuid libv4l
    mpg123 openssl portaudio SDL spandsp speex srtp zlib
  ];

  meta = with stdenv.lib; {
    description = "Baresip is a portable and modular SIP User-Agent";
    homepage = http://www.creytiv.com/baresip.html;
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
