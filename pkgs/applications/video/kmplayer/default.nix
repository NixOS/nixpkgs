{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, pango, gtk, dbus_glib, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kmplayer-0.11.2b";
  src = fetchurl {
    url = http://kmplayer.kde.org/pkgs/kmplayer-0.11.2b.tar.bz2;
    sha256 = "00a1pw31p849cbgskyfi8jni9ar6yi2ivr625vza2za6apdxvkr7";
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
