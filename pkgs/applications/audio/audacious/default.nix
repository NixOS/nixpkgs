{ stdenv, fetchurl, pkgconfig, glib, gtk, libmowgli, libmcs
, gettext, dbus_glib, libxml2, libmad, xlibs, alsaLib, libogg
, libvorbis, libcdio, libcddb, flac, ffmpeg
}:

let
  version = "3.2.1";
in
stdenv.mkDerivation {
  name = "audacious-${version}";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
    sha256 = "064a8d2887a0f92a1637df9d71b8eefa8064199c04eccfaac725f840cff6eac3";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
    sha256 = "5b7d3e52f6b8903bc01ae15651817e990d3348ae6b9734767f354eb2dbfc8c2d";
  };

  # `--enable-amidiplug' is to prevent configure from looking in /proc/asound.
  configureFlags = "--enable-amidiplug --disable-oss";

  buildInputs =
    [ gettext pkgconfig glib gtk libmowgli libmcs libxml2 dbus_glib
      libmad xlibs.libXcomposite libogg libvorbis flac alsaLib libcdio
      libcddb ffmpeg
    ];

  # Here we build bouth audacious and audacious-plugins in one
  # derivations, since they really expect to be in the same prefix.
  # This is slighly tricky.
  builder = builtins.toFile "builder.sh"
    ''
      # First build audacious.
      (
        source $stdenv/setup
        genericBuild
      )

      # Then build the plugins.
      (
        buildNativeInputs="$out $buildNativeInputs" # to find audacious
        source $stdenv/setup
        rm -rfv audacious-*
        src=$pluginsSrc
        genericBuild
      )
    '';

  enableParallelBuilding = true;

  meta = {
    description = "Audacious, a media player forked from the Beep Media Player, which was itself an XMMS fork";
    homepage = http://audacious-media-player.org/;
    maintainers = [ stdenv.lib.maintainers.eelco stdenv.lib.maintainers.simons ];
  };
}
