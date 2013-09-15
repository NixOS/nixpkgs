{ stdenv, fetchurl, qt }:

stdenv.mkDerivation rec {
  name = "tiled-qt-0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/tiled/${name}.tar.gz";
    sha256 = "09xm6ry56zsqbfl9fvlvc5kq9ikzdskm283r059q6rlc7crzhs38";
  };

  buildInputs = [ qt ];

  preConfigure = "qmake -r PREFIX=$out";

  meta = {
    description = "A free, easy to use and flexible tile map editor";
    homepage = "http://www.mapeditor.org/";
    # libtiled and tmxviewer is licensed under 2-calause BSD license.
    # The rest is GPL2 or later.
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };
}
