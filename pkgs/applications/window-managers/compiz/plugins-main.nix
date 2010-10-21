{ stdenv, fetchurl, intltool, pkgconfig, compiz, compiz_bcop
, getopt, libjpeg, cairo, pango, gnome }:

let version = "0.8.6"; in

stdenv.mkDerivation rec {
  name = "compiz-plugins-main-${version}";

  src = fetchurl {
    url = "http://releases.compiz.org/${version}/${name}.tar.bz2";
    sha256 = "1nfn3r4q7wvzfkdh9hrm5zc816xa8cs2s7cliz0fmnqikcs4zp36";
  };

  buildInputs =
    [ intltool pkgconfig compiz compiz_bcop getopt libjpeg cairo pango gnome.GConf ];

  meta = {
    homepage = http://www.compiz.org/;
    description = "Main plugins for Compiz";
    platforms = stdenv.lib.platforms.linux;
  };
}
