{ lib
, stdenv
, fetchurl
, aalib
, alsa-lib
, autoreconfHook
, ffmpeg
, flac
, libGL
, libGLU
, libX11
, libXext
, libXinerama
, libXv
, libcaca
, libcdio
, libmng
, libmpcdec
, libpulseaudio
, libtheora
, libv4l
, libvorbis
, libxcb
, ncurses
, perl
, pkg-config
, speex
, vcdimager
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xine-lib";
  version = "1.2.13";

  src = fetchurl {
    url = "mirror://sourceforge/xine/xine-lib-${finalAttrs.version}.tar.xz";
    hash = "sha256-XxDW1xikpRwX7RsysDHU+bgLBh6CdlNbK+MeWsS3Xm8=";
  };

  outputs = [ "out" "dev" "man" ];

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
  ];

  buildInputs = [
    aalib
    alsa-lib
    ffmpeg
    flac
    libGL
    libGLU
    libX11
    libXext
    libXinerama
    libXv
    libcaca
    libcdio
    libmng
    libmpcdec
    libpulseaudio
    libtheora
    libv4l
    libvorbis
    libxcb
    ncurses
    perl
    speex
    vcdimager
    zlib
    libX11
    libXext
    libXinerama
    libXv
    libxcb
  ];

  enableParallelBuilding = true;

  env.NIX_LDFLAGS = "-lxcb-shm";

  meta = {
    homepage = "https://xine.sourceforge.net/";
    description = "High-performance, portable and reusable multimedia playback engine";
    license = with lib.licenses; [ gpl2Plus lgpl2Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
