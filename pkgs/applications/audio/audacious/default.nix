{ stdenv, fetchurl, pkgconfig, glib, gtk3, libmowgli, libmcs
, gettext, dbus_glib, libxml2, libmad, xorg, alsaLib, libogg
, libvorbis, libcdio, libcddb, flac, ffmpeg, makeWrapper
, mpg123, neon, faad2, gnome3
}:

let version = "3.5.2"; in

stdenv.mkDerivation {
  name = "audacious-${version}";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
    sha256 = "0mhrdj76h0g6q197wgp8rxk6gqsrirrw49hfidcb5b7q5rlvj59r";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
    sha256 = "1nacd8n46q3pqnwavq3i2ayls609gvxfcp3qqpcsfcdfz3bh15hp";
  };

  buildInputs =
    [ gettext pkgconfig glib gtk3 libmowgli libmcs libxml2 dbus_glib
      libmad xorg.libXcomposite libogg libvorbis flac alsaLib libcdio
      libcddb ffmpeg makeWrapper mpg123 neon faad2 gnome3.defaultIconTheme
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

      (
        source $stdenv/setup
        # gsettings schemas for file dialogues
        # XDG_ICON_DIRS is set by hook for gnome3.defaultIconTheme
        for file in "$out/bin/"*; do
          wrapProgram "$file" \
            --prefix XDG_DATA_DIRS : "$XDG_ADD:$GSETTINGS_SCHEMAS_PATH" \
            --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
        done
      )
    '';
  XDG_ADD = gtk3 + "/share";

  enableParallelBuilding = true;

  meta = {
    description = "Audio player";
    homepage = http://audacious-media-player.org/;
    maintainers = with stdenv.lib.maintainers; [ eelco simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
