{ stdenv
, fetchurl
, ncurses
, libjpeg
, libX11
, libXt
, alsaLib
, aalib
, libXft
, xorgproto
, libv4l
, libFS
, libXaw
, libXpm
, libXext
, libSM
, libICE
, perl
}:

stdenv.mkDerivation rec {
  name = "xawtv-3.107";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/xawtv/${name}.tar.bz2";
    sha256 = "055p0wia0xsj073l8mg4ifa6m81dmv6p45qyh99brramq5iylfy5";
  };

  buildInputs = [
    ncurses
    libjpeg
    libX11
    libXt
    libXft
    xorgproto
    libFS
    perl
    alsaLib
    aalib
    libXaw
    libXpm
    libXext
    libSM
    libICE
    libv4l
  ];

  makeFlags = [
    "SUID_ROOT=" # do not try to setuid
    "resdir=${placeholder ''out''}/share/X11"
  ];

  meta = {
    description = "TV application for Linux with apps and tools such as a teletext browser";
    license = stdenv.lib.licenses.gpl2;
    homepage = "https://www.kraxel.org/blog/linux/xawtv/";
    maintainers = with stdenv.lib.maintainers; [ domenkozar ];
    platforms = stdenv.lib.platforms.linux;
  };
}
