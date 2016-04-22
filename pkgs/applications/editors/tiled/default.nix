{ stdenv, fetchurl, qtbase, qttools, qmakeHook, pkgconfig, python }:

let
  version = "0.12.3";
  sha256 = "001j4lvb5d9h3m6vgz2na07637x6xg4bdvxi2hg4a0j9rikb4y40";
in

stdenv.mkDerivation rec {
  name = "tiled-${version}";

  src = fetchurl {
    url = "https://github.com/bjorn/tiled/archive/v${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ qtbase qttools qmakeHook pkgconfig python ];

  meta = {
    description = "A free, easy to use and flexible tile map editor";
    homepage = "http://www.mapeditor.org/";
    # libtiled and tmxviewer is licensed under 2-calause BSD license.
    # The rest is GPL2 or later.
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
