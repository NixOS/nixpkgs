args: with args;

stdenv.mkDerivation rec {
  name = "xterm-231";
  src = fetchurl {
    url = "ftp://invisible-island.net/xterm/${name}.tgz";
    sha256 = "0qlz5nkdqkahdg9kbd1ni96n69srj1pd9yggwrw3z0kghaajb2sr";
  };
  buildInputs = [libXaw xproto libXt libXext libX11 libSM libICE ncurses
    freetype pkgconfig libXft luit];
  configureFlags = "--enable-wide-chars --enable-256-color
    --enable-load-vt-fonts --enable-i18n --enable-doublechars --enable-luit
    --enable-mini-luit --with-tty-group=tty";

  meta = {
    homepage = http://invisible-island.net/xterm;
  };
}

