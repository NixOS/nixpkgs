{ stdenv, fetchurl
, SDL, SDL_mixer, gstreamer, gstPluginsBase, gstFfmpeg
, libogg, libxml2, libjpeg, mesa, libpng, libungif, libtool
, boost, freetype, agg, dbus, curl, pkgconfig, gettext
, glib, gtk, x11, ming, dejagnu, python
, lib, makeWrapper }:

assert stdenv ? glibc;

let version = "0.8.6"; in

stdenv.mkDerivation rec {
  name = "gnash-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnash/${version}/${name}.tar.bz2";
    sha256 = "1sijafl5c5a005p8jxgn1cdmxkj7a6142dklrlzm9g55n9gbgx05";
  };

  builder = ./builder.sh;

  patchPhase = ''
    # Add all libs to `macros/libslist', a list of library search paths.
    for lib in ${lib.concatStringsSep " "
                                      (map (lib: "\"${lib}\"/lib")
                                           (buildInputs ++ [stdenv.glibc]))}
    do
      echo -n "$lib " >> macros/libslist
    done

    # Make sure to honor $TMPDIR, for chroot builds.
    for file in configure gui/Makefile.in Makefile.in
    do
      sed -i "$file" -es'|/tmp/|$TMPDIR/|g'
    done
  '';


  # XXX: KDE is supported as well so we could make it available optionally.
  buildInputs = [
    gettext x11 SDL SDL_mixer gstreamer gstPluginsBase gstFfmpeg libtool
    libogg libxml2 libjpeg mesa libpng libungif boost freetype agg
    dbus curl pkgconfig glib gtk
    makeWrapper

    # For the test suite
    ming dejagnu python
  ];

  inherit SDL_mixer SDL gstPluginsBase;

  # Make sure `gtk-gnash' gets `libXext' in its `RPATH'.
  NIX_LDFLAGS="-lX11 -lXext";

  #doCheck = true;

  preInstall = ''ensureDir $out/plugins'';
  postInstall = ''
    make install-plugins

    # Wrap programs so the find the GStreamer plug-ins they need
    # (e.g., gst-ffmpeg is needed to watch movies such as YouTube's).
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog" --prefix                                            \
        GST_PLUGIN_PATH ":"                                                     \
        "${gstPluginsBase}/lib/gstreamer-0.10:${gstFfmpeg}/lib/gstreamer-0.10"
    done
  '';

  meta = {
    homepage = http://www.gnu.org/software/gnash/;
    description = "GNU Gnash, a libre SWF (Flash) movie player";

    longDescription = ''
      Gnash is a GNU Flash movie player.  Flash is an animation file format
      pioneered by Macromedia which continues to be supported by their
      successor company, Adobe.  Flash has been extended to include audio and
      video content, and programs written in ActionScript, an
      ECMAScript-compatible language.  Gnash is based on GameSWF, and
      supports most SWF v7 features and some SWF v8 and v9.
    '';

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
} // {mozillaPlugin = "/plugins";}
