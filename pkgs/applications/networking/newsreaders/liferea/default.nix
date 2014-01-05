{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk2, gnome2 /*just GConf*/
, libsoup, libunique, libxslt, webkit_gtk2, json_glib
, libnotify /*optional*/ }:

let version = "1.8.15";
in
stdenv.mkDerivation rec {
  name = "liferea-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/liferea/Liferea%20Stable/${version}/${name}.tar.bz2";
    sha256 = "12hhdl5biwcvr9ds7pdhhvlp4vggjix6xm4z5pnfaz53ai2dnc99";
  };

  buildInputs = [
    pkgconfig intltool gtk2 gnome2.GConf
    libsoup libunique libxslt webkit_gtk2 json_glib
    libnotify
  ];

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache'';

  meta = {
    description = "A GTK-based news feed agregator";
    homepage = http://lzone.de/liferea/;
    maintainers = [ stdenv.lib.maintainers.vcunat ];
    platforms = stdenv.lib.platforms.linux;
  };
}
