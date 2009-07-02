{ stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi
, libjpeg, libpng, zlib, cairo

, # If you want the resulting program to call itself "Firefox" instead
  # of "Deer Park", enable this option.  However, those binaries may
  # not be distributed without permission from the Mozilla Foundation,
  # see http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:

stdenv.mkDerivation {
  name = "firefox-2.0.0.20";

  builder = ./2.0-builder.sh;

  src = fetchurl {
    url = http://releases.mozilla.org/pub/mozilla.org/firefox/releases/2.0.0.20/source/firefox-2.0.0.20-source.tar.bz2;
    sha1 = "16601fdbbb0a83b85fd053e76350f7da397f525e";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
  ];

  patches = [
    ./writable-copies.patch
    # Ugh, inexplicable problem since GTK+ 2.10.  Probably a Firefox
    # bug, but I don't know.  See
    # http://lists.gobolinux.org/pipermail/gobolinux-users/2007-January/004344.html
    ./xlibs.patch
  ];

  configureFlags = [
    "--enable-application=browser"
    "--enable-optimize"
    "--disable-debug"
    "--enable-xft"
    "--disable-freetype2"
    "--enable-svg"
    "--enable-canvas"
    "--enable-strip"
    "--enable-default-toolkit=gtk2"
    "--with-system-jpeg"
    "--with-system-png"
    "--with-system-zlib"
    "--enable-system-cairo"
  ]
  ++ (if enableOfficialBranding then ["--enable-official-branding"] else []);

  meta = {
    description = "Mozilla Firefox - the browser, reloaded";
    homepage = http://www.mozilla.com/en-US/firefox/;
  };

  passthru = {inherit gtk;};
}
