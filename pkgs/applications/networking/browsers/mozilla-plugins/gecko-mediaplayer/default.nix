{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, browser, x11
, GConf, gnome_mplayer, MPlayer
}:

stdenv.mkDerivation rec {
  name = "gecko-mediaplayer-1.0.4";

  src = fetchurl {
    url = "http://gecko-mediaplayer.googlecode.com/files/${name}.tar.gz";
    sha256 = "18asxxsqng303cxcww75k4r6syqjs7lylibv997kq0869kz4spsp";
  };

  buildInputs = [pkgconfig glib dbus dbus_glib browser x11 GConf browser.xulrunner];

  # !!! fix this
  preBuild =
    ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(echo ${browser.xulrunner}/include/xulrunner-*) -I${browser.nspr}/include/nspr"
      echo $NIX_CFLAGS_COMPILE
    '';

  # This plugin requires Gnome MPlayer and MPlayer to be in the
  # browser's $PATH.
  postInstall =
    ''
      echo "${gnome_mplayer}/bin:${MPlayer}/bin" > $out/${passthru.mozillaPlugin}/extra-bin-path
    '';

  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = {
    description = "A browser plugin that uses GNOME MPlayer to play media in a browser";
    homepage = http://kdekorte.googlepages.com/gecko-mediaplayer;
  };
}

