{stdenv, fetchurl, pkgconfig, glib, gtk, dbus, dbus_glib, GConf}:

stdenv.mkDerivation rec {
  name = "gnome-mplayer-0.9.6";

  src = fetchurl {
    url = "http://gnome-mplayer.googlecode.com/files/${name}.tar.gz";
    sha256 = "0gvciiy50y4vc9r6nlmw1q2fgwkywk0cq8rviswd6wbrxvz2gv2x";
  };

  buildInputs = [pkgconfig glib gtk dbus dbus_glib GConf];
  
  meta = {
    homepage = http://kdekorte.googlepages.com/gnomemplayer;
    description = "Gnome MPlayer, a simple GUI for MPlayer";
  };
}
