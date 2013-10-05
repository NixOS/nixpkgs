{ stdenv, fetchurl, pkgconfig, glib, gtk3, libmowgli, libmcs
, gettext, dbus_glib, libxml2, libmad, xlibs, alsaLib, libogg
, libvorbis, libcdio, libcddb, flac, ffmpeg
}:

let
  version = "3.3.4";
in
stdenv.mkDerivation {
  name = "audacious-${version}";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
    sha256 = "19zw4yj8g4fvxkv0ql8v8vgxzldxl1fzig239zzv88mpnvwxn737";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
    sha256 = "1l5g0zq73qp1hlrf4xsaj0n3hg0asrp7169531jgpncjn15dhvdn";
  };

  buildInputs =
    [ gettext pkgconfig glib gtk3 libmowgli libmcs libxml2 dbus_glib
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
        nativeBuildInputs="$out $nativeBuildInputs" # to find audacious
        source $stdenv/setup
        rm -rfv audacious-*
        src=$pluginsSrc
        genericBuild
      )
    '';

  enableParallelBuilding = true;

  meta = {
    description = "Audio player";
    homepage = http://audacious-media-player.org/;
    maintainers = with stdenv.lib.maintainers; [ eelco simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
