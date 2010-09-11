{stdenv, fetchurl, pkgconfig, glib, gtk, dbus, dbus_glib, GConf}:

stdenv.mkDerivation rec {
  name = "gnome-mplayer-0.9.99.rc1";

  src = fetchurl {
    url = "http://gnome-mplayer.googlecode.com/files/${name}.tar.gz";
    sha256 = "00fbcjpashrld8bpvm63q9ms17kjnj3rrn1ghsfyqi2swpwzk2k1";
  };

  buildInputs = [pkgconfig glib gtk dbus dbus_glib GConf];
  
  meta = {
    homepage = http://kdekorte.googlepages.com/gnomemplayer;
    description = "Gnome MPlayer, a simple GUI for MPlayer";
  };
}
