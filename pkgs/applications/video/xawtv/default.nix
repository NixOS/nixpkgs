{stdenv, fetchurl, ncurses, libjpeg, libX11, libXt, libXft, xproto, libFS, fontsproto, libXaw, libXpm, libXext, libSM, libICE, perl, xextproto, linux}:

stdenv.mkDerivation {
  name = "xawtv-3.95";
  src = fetchurl {
    url = http://dl.bytesex.org/releases/xawtv/xawtv-3.95.tar.gz;
    md5 = "ad25e03f7e128b318e392cb09f52207d";
  };
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(echo ${linux}/lib/modules/*/build/include)"
  '';
  buildInputs = [ncurses libjpeg libX11 libXt libXft xproto libFS fontsproto libXaw libXpm libXext libSM libICE perl xextproto];
  patches = [./xawtv-3.95-libfs.patch ./xawtv-3.95-makefile.patch ./xawtv-3.95-page-mask.patch ];
  
}
