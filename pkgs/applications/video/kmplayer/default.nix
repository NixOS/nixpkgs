{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, pango, gtk, dbus_glib, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kmplayer-0.11.2c";
  src = fetchurl {
    url = http://kmplayer.kde.org/pkgs/kmplayer-0.11.2c.tar.bz2;
    sha256 = "1qhafq865bzpz6m9k7cjdv4884qfpn481ak77ly0nidpq2ab0l9m";
  };
  builder = ./builder.sh;
  buildInputs = [ cmake qt4 perl gettext stdenv.gcc.libc pango gtk dbus_glib kdelibs automoc4 phonon ];
  meta = {
    description = "MPlayer front-end for KDE";
    license = "GPL";
    homepage = http://kmplayer.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
