{ stdenv, fetchurl, pkgconfig, glib, gtk, libmowgli, libmcs
, gettext, dbus_glib, libxml2, libmad, xlibs, alsaLib, libogg
, libvorbis, libcdio, libcddb, flac, ffmpeg
}:

stdenv.mkDerivation rec {
  name = "audacious-3.0";
  
  src = fetchurl {
    url = "http://distfiles.atheme.org/${name}.tar.gz";
    sha256 = "0kj78hgf73fmbm6y3idir2kavbnnlv0jb9ka0pcsb12sxb994s68";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.atheme.org/audacious-plugins-3.0.tar.gz";
    sha256 = "0hhxk1mxnnrb1shshpf1nf8mqpc9q1qpsljwn4jzylcnwy6pq4rw";
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
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
