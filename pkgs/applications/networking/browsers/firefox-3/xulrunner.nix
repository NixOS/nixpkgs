{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, libpng, zlib, cairo, dbus, dbus_glib, bzip2, xlibs
, freetype, fontconfig, file

, # If you want the resulting program to call itself "Firefox" instead
  # of "Deer Park", enable this option.  However, those binaries may
  # not be distributed without permission from the Mozilla Foundation,
  # see http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
}:

stdenv.mkDerivation {
  name = "xulrunner-1.9.0.1";

  src = fetchurl {
    url = http://releases.mozilla.org/pub/mozilla.org/firefox/releases/3.0.1/source/firefox-3.0.1-source.tar.bz2;
    sha1 = "ba3bb0b02404cf1abfb6189b156b2f4eb02e8975";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libjpeg libpng zlib cairo bzip2
    python dbus dbus_glib pango freetype fontconfig
    xlibs.libXi xlibs.libX11 xlibs.libXrender xlibs.libXft xlibs.libXt
    file
  ];

  configureFlags = [
    "--enable-application=xulrunner"
    "--disable-javaxpcom"
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

  installFlags = [
    "SKIP_GRE_REGISTRATION=1"
  ];

  postInstall = ''
    export dontPatchELF=1;

    # Strip some more stuff
    strip -S $out/lib/*/* || true

    # Fix some references to /bin paths in the Firefox shell script.
    substituteInPlace $out/bin/xulrunner \
        --replace /bin/pwd "$(type -tP pwd)" \
        --replace /bin/ls "$(type -tP ls)"
    
    # Fix run-mozilla.sh search
    libDir=$(cd $out/lib && ls -d xulrunner-[0-9]*)
    echo libDir: $libDir
    test -n "$libDir"
    cd $out/bin
    mv xulrunner ../lib/$libDir/

    for i in $out/lib/$libDir/*; do 
        file $i;
        if file $i | grep executable &>/dev/null; then 
	    ln -s $i $out/bin
        fi;
    done;
    rm $out/bin/run-mozilla.sh || true
  ''; # */

  meta = {
    description = "Mozilla Firefox XUL runner";
    homepage = http://www.mozilla.com/en-US/firefox/;
  };

  passthru = {inherit gtk;};
}


