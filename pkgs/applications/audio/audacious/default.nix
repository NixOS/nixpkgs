{ stdenv, fetchurl, pkgconfig, glib, gtk3, libmowgli, libmcs
, gettext, dbus_glib, libxml2, libmad, xlibs, alsaLib, libogg
, libvorbis, libcdio, libcddb, flac, ffmpeg, makeWrapper
}:

let
  version = "3.4.3";
in
stdenv.mkDerivation {
  name = "audacious-${version}";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
    sha256 = "04lzwdr1lx6ghbfxzygvnbmdl420w6rm453ds5lyb0hlvzs58d0q";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
    sha256 = "00r88q9fs9a0gicdmk2svcans7igcqgacrw303a5bn44is7pmrmy";
  };

  buildInputs =
    [ gettext pkgconfig glib gtk3 libmowgli libmcs libxml2 dbus_glib
      libmad xlibs.libXcomposite libogg libvorbis flac alsaLib libcdio
      libcddb ffmpeg makeWrapper
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
        for file in "$out/bin/"*; do
          wrapProgram "$file" --prefix XDG_DATA_DIRS : "$XDG_ADD:$GSETTINGS_SCHEMAS_PATH"
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
