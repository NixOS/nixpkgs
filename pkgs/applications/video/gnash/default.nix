{ stdenv, fetchurl, fetchpatch
, SDL, SDL_mixer, gstreamer, gst_plugins_base, gst_plugins_good
, gst_ffmpeg, speex
, libogg, libxml2, libjpeg, mesa, libpng, libungif, libtool
, boost, freetype, agg, dbus, curl, pkgconfig, gettext
, glib, gtk, gtkglext, pangox_compat, xlibsWrapper, ming, dejagnu, python, perl
, freefont_ttf, haxe, swftools
, lib, makeWrapper
, xulrunner }:

assert stdenv ? glibc;

let version = "0.8.10";
    patch_CVE = fetchpatch {
      url = "http://git.savannah.gnu.org/cgit/gnash.git/patch/?id=bb4dc77eecb6ed1b967e3ecbce3dac6c5e6f1527";
      sha256 = "0ghnki5w7xf3qwfl1x6vhijpd6q608niyxrvh0g8dw5xavkvallk";
      name = "CVE-2012-1175.patch";
    };
in

stdenv.mkDerivation rec {
  name = "gnash-${version}";

  src = fetchurl {
    url = "mirror://gnu/gnash/${version}/${name}.tar.bz2";
    sha256 = "090j5lly5r6jzbnvlc3mhay6dsrd9sfrkjcgqaibm4nz8lp0f9cn";
  };

  patchPhase = ''
    patch -p1 < ${patch_CVE}

    # Add all libs to `macros/libslist', a list of library search paths.
    libs=$(echo "$NIX_LDFLAGS" | tr ' ' '\n' | sed -n 's/.*-L\(.*\).*/\1/p')
    for lib in $libs; do
      echo -n "$lib " >> macros/libslist
    done
    echo -n "${stdenv.glibc.out}/lib" >> macros/libslist

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
    gettext xlibsWrapper SDL SDL_mixer gstreamer gst_plugins_base gst_plugins_good
    gst_ffmpeg speex libtool
    libogg libxml2 libjpeg mesa libpng libungif boost freetype agg
    dbus curl pkgconfig glib gtk gtkglext pangox_compat
    xulrunner
    makeWrapper
  ]

  ++ (stdenv.lib.optionals doCheck [
        ming dejagnu python perl haxe swftools
      ]);

  preConfigure =
    '' configureFlags="                                         \
         --with-sdl-incl=${SDL.dev}/include/SDL                     \
         --with-npapi-plugindir=$out/plugins                    \
         --enable-media=gst                                     \
         --without-gconf
         --enable-gui=gtk"

       # In `libmedia', Gnash compiles with "-I$gst_plugins_base/include",
       # whereas it really needs "-I$gst_plugins_base/include/gstreamer-0.10".
       # Work around this using GCC's $CPATH variable.
       export CPATH="${gst_plugins_base}/include/gstreamer-0.10:${gst_plugins_good}/include/gstreamer-0.10"
       echo "\$CPATH set to \`$CPATH'"

       echo "\$GST_PLUGIN_PATH set to \`$GST_PLUGIN_PATH'"
    '';

  postConfigure = "echo '#define nullptr NULL' >> gnashconfig.h";

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
      wrapProgram "$prog" --prefix GST_PLUGIN_SYSTEM_PATH ":" "$GST_PLUGIN_SYSTEM_PATH"
    done
  '';

  meta = {
    homepage = http://www.gnu.org/software/gnash/;
    description = "A libre SWF (Flash) movie player";

    longDescription = ''
      Gnash is a GNU Flash movie player.  Flash is an animation file format
      pioneered by Macromedia which continues to be supported by their
      successor company, Adobe.  Flash has been extended to include audio and
      video content, and programs written in ActionScript, an
      ECMAScript-compatible language.  Gnash is based on GameSWF, and
      supports most SWF v7 features and some SWF v8 and v9.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;
    broken = true;
  };
} // {mozillaPlugin = "/plugins";}
