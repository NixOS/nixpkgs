{stdenv, fetchurl, ncurses, libjpeg, libX11, libXt, alsaLib, aalib, libXft, xproto, libv4l
, libFS, fontsproto, libXaw, libXpm, libXext, libSM, libICE, perl, xextproto, linux}:

stdenv.mkDerivation rec {
  name = "xawtv-3.103";
  src = fetchurl {
    url = "http://linuxtv.org/downloads/xawtv/${name}.tar.bz2";
    sha256 = "0lnxr3xip80g0rz7h6n14n9d1qy0cm56h0g1hsyr982rbldskwrc";
  };

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${linux}/lib/modules/${linux.modDirVersion}/build"
  '';

  configureFlags="--prefix=";
  NIX_LDFLAGS="-lgcc_s";

  makeFlags = "SUID_ROOT= DESTDIR=\$(out) PREFIX=";

  buildInputs = [ncurses libjpeg libX11 libXt libXft xproto libFS perl alsaLib aalib
                 fontsproto libXaw libXpm libXext libSM libICE xextproto libv4l];

  meta = {
    description = "TV application for Linux with apps and tools such as a teletext browser";
    license = stdenv.lib.licenses.gpl2;
    homePage = https://www.kraxel.org/blog/linux/xawtv/;
    maintainers = with stdenv.lib.maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.linux;
  };
  
}
