{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, browser, xlibsWrapper
, GConf, gnome_mplayer, mplayer, gmtk
}:

stdenv.mkDerivation rec {
  name = "gecko-mediaplayer-1.0.5";

  src = fetchurl {
    url = "http://gecko-mediaplayer.googlecode.com/files/${name}.tar.gz";
    sha256 = "913fd39e70c564cb210c2544a88869f9d1a448184421f000b14b2bc5ba718b49";
  };

  buildInputs = [ pkgconfig glib dbus dbus_glib browser xlibsWrapper GConf browser gmtk ];

  # !!! fix this
  preBuild =
    ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$(echo ${browser}/include/xulrunner-*) -I${browser.nspr.dev}/include/nspr"
      echo $NIX_CFLAGS_COMPILE
    '';

  # This plugin requires Gnome MPlayer and MPlayer to be in the
  # browser's $PATH.
  postInstall =
    ''
      echo "${gnome_mplayer}/bin:${mplayer}/bin" > $out/${passthru.mozillaPlugin}/extra-bin-path
    '';

  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = {
    description = "A browser plugin that uses GNOME MPlayer to play media in a browser";
    homepage = http://kdekorte.googlepages.com/gecko-mediaplayer;
    broken = true;
  };
}

