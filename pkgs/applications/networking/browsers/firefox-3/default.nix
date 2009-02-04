{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, zlib, cairo, dbus, dbus_glib, bzip2
, freetype, fontconfig, xulrunner

, # If you want the resulting program to call itself "Firefox" instead
  # of "Deer Park", enable this option.  However, those binaries may
  # not be distributed without permission from the Mozilla Foundation,
  # see http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:

stdenv.mkDerivation {
  name = "firefox-3.0.6";

  src = fetchurl {
    # Don't forget to update xulrunner.nix as well!
    url = http://releases.mozilla.org/pub/mozilla.org/firefox/releases/3.0.6/source/firefox-3.0.6-source.tar.bz2;
    sha1 = "e2845c07b507308664f6f39086a050b2773382fb";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libjpeg zlib cairo bzip2
    python dbus dbus_glib pango freetype fontconfig
  ];

  propagatedBuildInputs = [xulrunner];

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
    "--with-libxul-sdk=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"
  ];

  postInstall = ''
    # Strip some more stuff.
    strip -S $out/lib/*/* || true

    libDir=$(cd $out/lib && ls -d firefox-[0-9]*)
    test -n "$libDir"
    
    ln -s ${xulrunner}/lib/xulrunner-${xulrunner.version} $out/lib/$libDir/xulrunner

    # Register extensions etc. !!! is this needed anymore?
    echo "running firefox -register..."
    $out/bin/firefox -register
  ''; # */

  meta = {
    description = "Mozilla Firefox - the browser, reloaded";
    homepage = http://www.mozilla.com/en-US/firefox/;
  };

  passthru = {
    inherit gtk;
    isFirefox3Like = true;
  };
}


