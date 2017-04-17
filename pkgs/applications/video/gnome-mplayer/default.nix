{stdenv, fetchurl, pkgconfig, glib, gtk2, dbus, dbus_glib, GConf}:

stdenv.mkDerivation rec {
  name = "gnome-mplayer-1.0.4";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/gnome-mplayer/${name}.tar.gz";
    sha256 = "1k5yplsvddcm7xza5h4nfb6vibzjcqsk8gzis890alizk07f5xp2";
  };

  buildInputs = [pkgconfig glib gtk2 dbus dbus_glib GConf];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://kdekorte.googlepages.com/gnomemplayer;
    description = "Gnome MPlayer, a simple GUI for MPlayer";
  };
}
