{stdenv, fetchurl, ncurses, libjpeg, libX11, libXt, alsaLib, aalib, libXft, xproto, libv4l
, libFS, fontsproto, libXaw, libXpm, libXext, libSM, libICE, perl, xextproto, linux}:

stdenv.mkDerivation rec {
  name = "xawtv-3.104";
  src = fetchurl {
    url = "https://linuxtv.org/downloads/xawtv/${name}.tar.bz2";
    sha256 = "0jnvbahxmx9jw8g2519wmc1dq9afnlqcrzc876fcbf2x1iz39qxr";
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
    homepage = https://www.kraxel.org/blog/linux/xawtv/;
    maintainers = with stdenv.lib.maintainers; [ domenkozar ];
    platforms = stdenv.lib.platforms.linux;
  };
  
}
