{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, cairo, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig

, # If you want the resulting program to call itself "Firefox" instead
  # of "Deer Park", enable this option.  However, those binaries may
  # not be distributed without permission from the Mozilla Foundation,
  # see http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:

stdenv.mkDerivation {
  name = "firefox-3.0.3";

  src = fetchurl {
    url = http://releases.mozilla.org/pub/mozilla.org/firefox/releases/3.0.3/source/firefox-3.0.3-source.tar.bz2;
    sha1 = "089a41ff079cd37d39d19cf3a51daba07337db2c";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libjpeg libpng zlib cairo bzip2
    python dbus dbus_glib pango freetype fontconfig
    xlibs.libXi xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt
  ];

  configureFlags = [
    "--enable-application=browser"
    "--enable-optimize"
    "--disable-debug"
    "--enable-strip"
    "--with-system-jpeg"
    "--with-system-zlib"
    "--with-system-bz2"
    # "--with-system-png" # <-- "--with-system-png won't work because the system's libpng doesn't have APNG support"
    "--enable-system-cairo"
    #"--enable-system-sqlite" # <-- this seems to be discouraged
    "--disable-crashreporter"
  ];

  postInstall = ''
    export dontPatchELF=1;

    # Strip some more stuff
    strip -S $out/lib/*/* || true

    # Fix some references to /bin paths in the Firefox shell script.
    substituteInPlace $out/bin/firefox \
        --replace /bin/pwd "$(type -tP pwd)" \
        --replace /bin/ls "$(type -tP ls)"
    
    # This fixes starting Firefox when there already is a running
    # instance.  The `firefox' wrapper script actually expects to be
    # in the same directory as `run-mozilla.sh', apparently.
    libDir=$(cd $out/lib && ls -d firefox-[0-9]*)
    test -n "$libDir"
    cd $out/bin
    mv firefox ../lib/$libDir/
    ln -s ../lib/$libDir/firefox .

    # Register extensions etc.
    echo "running firefox -register..."
    (cd $out/lib/$libDir && LD_LIBRARY_PATH=. ./firefox-bin -register) || false

    # Put the Firefox icon in the right place.
    ensureDir $out/lib/$libDir/chrome/icons/default
    ln -s ../../../icons/default.xpm  $out/lib/$libDir/chrome/icons/default/
  ''; # */

  meta = {
    description = "Mozilla Firefox - the browser, reloaded";
    homepage = http://www.mozilla.com/en-US/firefox/;
  };

  passthru = {inherit gtk;};
}


