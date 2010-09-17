{ stdenv, fetchurl, pkgconfig, glib, gtk, libmowgli, libmcs
, gettext, dbus_glib, libxml2, libmad, xlibs, alsaLib, libogg
, libvorbis, libcdio, libcddb, flac, ffmpeg
}:

stdenv.mkDerivation rec {
  name = "audacious-2.4.0";
  
  src = fetchurl {
    url = "http://distfiles.atheme.org/${name}.tgz";
    sha256 = "1n6mfy2j7lqv5d9r92n1frbs7acplfip5vssqp0j9z5qkidx98pj";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.atheme.org/audacious-plugins-2.4.0.tgz";
    sha256 = "04rsfh7c54ffz6qavl3li5haa7jnaa42m4p1w0s4qpiiw3pvbaf5";
  };
  
  # `--enable-amidiplug' is to prevent configure from looking in /proc/asound.
  configureFlags = "--enable-amidiplug";
  
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

  meta = {
    description = "Audacious, a media player forked from the Beep Media Player, which was itself an XMMS fork";
    homepage = http://audacious-media-player.org/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
