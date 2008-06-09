args: with args;

stdenv.mkDerivation {
  name = "firefox-3.0-beta-3";

  src = fetchurl {
    url = http://releases.mozilla.org/pub/mozilla.org/firefox/releases/3.0rc2/source/firefox-3.0rc2-source.tar.bz2;
    #url = http://releases.mozilla.org/pub/mozilla.org/firefox/releases/3.0b5/source/firefox-3.0b5-source.tar.bz2;
    #url = ftp://ftp.mozilla.org/pub/firefox/releases/3.0b4/source/firefox-3.0b5-source.tar.bz2;
    sha256 = "13g1ipnjxq4ssfj6f6pdp9rjdadb5sydfsgx6a5pqvxhzch5nq6i";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
    python curl coreutils dbus dbus_glib pango freetype fontconfig 
    libX11 libXrender libXft libXt
  ];

  configureFlags = [
    "--enable-application=browser"
    "--enable-optimize"
    "--disable-debug"
    "--enable-strip"
    "--with-system-jpeg"
    "--with-system-zlib"
    #"--with-system-png" <-- "--with-system-png won't work because the system's libpng doesn't have APNG support"
    #"--enable-system-cairo" <-- disabled for now because Firefox needs a alpha version of Cairo
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


