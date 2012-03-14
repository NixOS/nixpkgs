{ stdenv, fetchurl
, SDL, SDL_mixer, gstreamer, gst_plugins_base, gst_plugins_good
, gst_ffmpeg, speex
, libogg, libxml2, libjpeg, mesa, libpng, libungif, libtool
, boost, freetype, agg, dbus, curl, pkgconfig, gettext
, glib, gtk, gtkglext, x11, ming, dejagnu, python, perl
, freefont_ttf, haxe, swftools
, lib, makeWrapper
, xulrunner }:

assert stdenv ? glibc;

let version = "0.8.9"; in

stdenv.mkDerivation rec {
  name = "gnash-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnash/${version}/${name}.tar.bz2";
    sha256 = "1ga8khwaympj4fphhpyqx6ddcikv0zmcpnlykcipny1xy33bs3gr";
  };

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

    # Provide a default font.
    sed -i "configure" \
        -e 's|/usr/share/fonts/truetype/freefont/|${freefont_ttf}/share/fonts/truetype/|g'
  '';

  enableParallelBuilding = true;

  # XXX: KDE is supported as well so we could make it available optionally.
  buildInputs = [
    gettext x11 SDL SDL_mixer gstreamer gst_plugins_base gst_plugins_good
    gst_ffmpeg speex libtool
    libogg libxml2 libjpeg mesa libpng libungif boost freetype agg
    dbus curl pkgconfig glib gtk gtkglext
    xulrunner
    makeWrapper
  ]

  ++ (stdenv.lib.optionals doCheck [
        ming dejagnu python perl haxe swftools
      ]);

  preConfigure =
    '' configureFlags="                                         \
         --with-sdl-incl=${SDL}/include/SDL                     \
         --with-npapi-plugindir=$out/plugins                    \
         --enable-media=gst                                     \
         --enable-gui=gtk"

       # In `libmedia', Gnash compiles with "-I$gst_plugins_base/include",
       # whereas it really needs "-I$gst_plugins_base/include/gstreamer-0.10".
       # Work around this using GCC's $CPATH variable.
       export CPATH="${gst_plugins_base}/include/gstreamer-0.10:${gst_plugins_good}/include/gstreamer-0.10"
       echo "\$CPATH set to \`$CPATH'"

       echo "\$GST_PLUGIN_PATH set to \`$GST_PLUGIN_PATH'"
    '';

  # Make sure `gtk-gnash' gets `libXext' in its `RPATH'.
  NIX_LDFLAGS="-lX11 -lXext";

  # XXX: Tests currently fail.
  doCheck = false;

  preInstall = ''mkdir -p $out/plugins'';
  postInstall = ''
    make install-plugins

    # Wrap programs so the find the GStreamer plug-ins they need
    # (e.g., gst-ffmpeg is needed to watch movies such as YouTube's).
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog" --prefix                                            \
        GST_PLUGIN_PATH ":"                                                     \
        "${gst_plugins_base}/lib/gstreamer-0.10:${gst_plugins_good}/lib/gstreamer-0.10:${gst_ffmpeg}/lib/gstreamer-0.10"
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
