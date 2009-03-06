{ stdenv, fetchurl
, SDL, SDL_mixer, gstreamer, gstPluginsBase, gstFfmpeg
, libogg, libxml2, libjpeg, mesa, libpng, libungif, libtool
, boost, freetype, agg, dbus, curl, pkgconfig, gettext
, glib, gtk, x11, ming, dejagnu, python
, lib, makeWrapper }:

let version = "0.8.5"; in
stdenv.mkDerivation rec {
  name = "gnash-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnash/${version}/${name}.tar.bz2";
    sha256 = "1cqhnbp99rb0n4x2bsz8wwh7vvc2kclxc1wmrl5vaapd9qhp5whn";
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

  inherit SDL_mixer SDL;

  # Make sure `gtk-gnash' gets `libXext' in its `RPATH'.
  NIX_LDFLAGS="-lX11 -lXext";

  #doCheck = true;

  preInstall = ''ensureDir $out/plugins'';
  postInstall = ''
    make install-plugins

    # Wrap programs so the find the GStreamer plug-ins they need
    # (e.g., gst-ffmpeg is needed to watch movies such as YouTube's).
    for prog in $out/bin/*
    do
      wrapProgram "$prog" --prefix                                              \
        GST_PLUGIN_PATH ":"                                                     \
        "${gstPluginsBase}/lib/gstreamer-0.10:${gstFfmpeg}/lib/gstreamer-0.10"
    done
  '';

  meta = {
    homepage = http://www.gnu.org/software/gnash/;
    description = "GNU Gnash, an SWF movie player";
    license = "GPLv3+";
  };
} // {mozillaPlugin = "/plugins";}
