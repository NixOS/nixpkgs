{ stdenv, fetchurl, intltool, pkgconfig, libX11, gtk }:

stdenv.mkDerivation rec {
  name = "lxappearance-0.6.1";
  src = fetchurl{
    url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
    sha256 = "1phnv1b2jdj2vlibjyc9z01izcf3k5zxj8glsaf0i3vh77zqmqq9";
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
