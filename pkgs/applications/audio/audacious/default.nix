{ stdenv, fetchurl, pkgconfig, glib, gtk, libmowgli, libmcs
, gettext, dbus_glib, libxml2, libmad, xlibs, alsaLib, libogg
, libvorbis, libcdio, libcddb, flac 
}:

stdenv.mkDerivation rec {
  name = "audacious-2.3";
  
  src = fetchurl {
    url = "http://distfiles.atheme.org/${name}.tgz";
    sha256 = "0vs16y1vrlkzcbaw8imc36b9lncva69zkdkp38ikbidssiskm6xi";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.atheme.org/audacious-plugins-2.3.tgz";
    sha256 = "0hdami52qpiyim3nz3qnml85wgjzpmx6g2wahfnsdvncmhm4v93x";
  };
  
  # `--enable-amidiplug' is to prevent configure from looking in /proc/asound.
  configureFlags = "--enable-amidiplug";
  
  buildInputs =
    [ gettext pkgconfig glib gtk libmowgli libmcs libxml2 dbus_glib
      libmad xlibs.libXcomposite libogg libvorbis flac alsaLib libcdio
      libcddb
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
