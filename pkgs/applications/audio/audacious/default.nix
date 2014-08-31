{ stdenv, fetchurl, pkgconfig, glib, gtk3, libmowgli, libmcs
, gettext, dbus_glib, libxml2, libmad, xlibs, alsaLib, libogg
, libvorbis, libcdio, libcddb, flac, ffmpeg, makeWrapper
, mpg123, neon, faad2
}:

let
  version = "3.5.1";
in
stdenv.mkDerivation {
  name = "audacious-${version}";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
    sha256 = "01wmlvpp540gdjw759wif3byh98h3b3q6f5wawzp0b0ivqd0wf6z";
  };

  pluginsSrc = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
    sha256 = "09lyvi15hbn3pvb2izyz2bm4021917mhcdrwxrn3q3sjvx337np6";
  };

  buildInputs =
    [ gettext pkgconfig glib gtk3 libmowgli libmcs libxml2 dbus_glib
      libmad xlibs.libXcomposite libogg libvorbis flac alsaLib libcdio
      libcddb ffmpeg makeWrapper mpg123 neon faad2
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
