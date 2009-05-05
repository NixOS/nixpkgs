{ stdenv, fetchurl, pkgconfig, gtk, pango, perl, python, zip, libIDL
, libjpeg, zlib, cairo, dbus, dbus_glib, bzip2
, freetype, fontconfig, xulrunner, alsaLib, autoconf

, # If you want the resulting program to call itself "Firefox" instead
  # of "Deer Park", enable this option.  However, those binaries may
  # not be distributed without permission from the Mozilla Foundation,
  # see http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:

let version = "3.5b4"; in

stdenv.mkDerivation {
  name = "firefox-${version}";

  src = fetchurl {
    url = "ftp://ftp.mozilla.org/pub/firefox/releases/${version}/source/firefox-${version}-source.tar.bz2";
    sha256 = "0pfrcqbsa88p6nfqx7xhlr603ycwf5lnfmwcdd5abl7xipxg4lxn";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libjpeg zlib cairo bzip2
    python dbus dbus_glib pango freetype fontconfig alsaLib
    autoconf
  ];

  propagatedBuildInputs = [xulrunner];

  preConfigure = ''
    export PREFIX=$out
    export LIBXUL_DIST=$out
    autoconf
    cd js/src
    autoconf
    cd ../..
  '';

  preBuild = ''
    cd nsprpub
    autoconf 
    ./configure
    make
    cd ..
  '';

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
