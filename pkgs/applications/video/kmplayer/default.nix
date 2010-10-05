{stdenv, fetchurl, lib, cmake, qt4, perl, gettext, pango, gtk, dbus_glib, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kmplayer-0.11.2a";
  src = fetchurl {
    url = http://kmplayer.kde.org/pkgs/kmplayer-0.11.2a.tar.bz2;
    sha256 = "1ddrghwsz11nhdxkca7jz0q2z1ajdb47n325h32jp5q7rm2qz80k";
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
