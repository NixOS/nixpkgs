{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, browser, x11
, GConf, gnome_mplayer, MPlayer
}:

stdenv.mkDerivation rec {
  name = "gecko-mediaplayer-0.9.6";

  src = fetchurl {
    url = "http://gecko-mediaplayer.googlecode.com/files/${name}.tar.gz";
    sha256 = "1847jv1v9r4xzmvksvjvl2fmp8j5s22hx922hywdflzzq7jsgyr7";
  };

  buildInputs = [pkgconfig glib dbus dbus_glib browser x11 GConf];

  # !!! fix this
  preBuild =
    ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${browser.xulrunner}/include/xulrunner-1.9.1/stable/ -I${browser.nspr}/include/nspr"
      echo $NIX_CFLAGS_COMPILE
    '';

  # This plugin requires Gnome MPlayer and MPlayer to be in the
  # browser's $PATH.
  postInstall =
    ''
      echo "${gnome_mplayer}/bin:${MPlayer}/bin" > $out/${passthru.mozillaPlugin}/extra-bin-path
    '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = {
    description = "A browser plugin that uses GNOME MPlayer to play media in a browser";
    homepage = http://kdekorte.googlepages.com/gecko-mediaplayer;
  };
}

