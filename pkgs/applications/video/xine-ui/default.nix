{stdenv, fetchurl, x11, xineLib, libpng}:

stdenv.mkDerivation {
  name = "xine-ui-0.99.2";
#  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/xine/xine-ui-0.99.2.tar.gz;
    md5 = "4a4cf5cc68bf65e6845f501ea87fdf94";
  };
  buildInputs = [x11 xineLib libpng];
  configureFlags = "--without-readline";
}
