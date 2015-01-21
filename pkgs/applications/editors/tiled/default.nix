{ stdenv, fetchurl, qt }:

stdenv.mkDerivation rec {
  name = "tiled-0.11.0";

  src = fetchurl {
    url = "https://github.com/bjorn/tiled/archive/v0.11.0.tar.gz";
    sha256 = "03a15vbzjfwc8dpifbjvd0gnr208mzmdkgs2nlc8zq6z0a4h4jqd";
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
