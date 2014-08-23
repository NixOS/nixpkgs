{ stdenv, fetchurl, intltool, pkgconfig, libX11, gtk }:

stdenv.mkDerivation rec {
  name = "lxappearance-0.5.5";
  src = fetchurl{
    url = "http://downloads.sourceforge.net/project/lxde/LXAppearance/${name}.tar.xz";
    sha256 = "8cae82e6425ba8a0267774e4d10096df2d91b0597520058331684a5ece068b4c";
  };
  buildInputs = [ intltool libX11 pkgconfig gtk ];
  meta = {
    description = "A lightweight program for configuring the theme and fonts of gtk applications";
    maintainers = [ stdenv.lib.maintainers.hinton ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://lxappearance.sourceforce.net/";
  };
}
