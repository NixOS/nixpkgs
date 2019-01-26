{stdenv, fetchurl, ncurses, libjpeg, libX11, libXt, alsaLib, aalib, libXft, xorgproto, libv4l
, libFS, libXaw, libXpm, libXext, libSM, libICE, perl, linux}:

stdenv.mkDerivation rec {
  name = "xawtv-3.105";
  src = fetchurl {
    url = "https://linuxtv.org/downloads/xawtv/${name}.tar.bz2";
    sha256 = "03v4k0dychjz1kj890d9pc7v8jh084m01g71x1clmmvc6vc9kn1b";
  };

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${linux}/lib/modules/${linux.modDirVersion}/build"
  '';

  configureFlags= [ "--prefix=" ];

  NIX_LDFLAGS = "-lgcc_s";

  makeFlags = "SUID_ROOT= DESTDIR=\$(out) PREFIX=";

  buildInputs = [ncurses libjpeg libX11 libXt libXft xorgproto libFS perl alsaLib aalib
                 libXaw libXpm libXext libSM libICE libv4l];

  meta = {
    description = "TV application for Linux with apps and tools such as a teletext browser";
    license = stdenv.lib.licenses.gpl2;
    homepage = https://www.kraxel.org/blog/linux/xawtv/;
    maintainers = with stdenv.lib.maintainers; [ domenkozar ];
    platforms = stdenv.lib.platforms.linux;
  };
  
}
