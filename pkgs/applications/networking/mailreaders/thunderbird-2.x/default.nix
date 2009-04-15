{ stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi
, libjpeg, libpng, zlib, cairo

, # If you want the resulting program to call itself "Thunderbird"
  # instead of "Mail", enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:

stdenv.mkDerivation {
  name = "thunderbird-2.0.0.21";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = ftp://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/2.0.0.21/source/thunderbird-2.0.0.21-source.tar.bz2;
    sha1 = "8bb2f7ce60635f6082c3c4542fff10c4b7445dc0";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
  ];

  patches = [
    # Ugh, inexplicable problem since GTK+ 2.10.  Probably a Firefox
    # bug, but I don't know.  See
    # http://lists.gobolinux.org/pipermail/gobolinux-users/2007-January/004344.html
    ./xlibs.patch
  ];

  configureFlags = [
    "--enable-application=mail"
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
    "--enable-extensions=default"
  ]
  ++ (if enableOfficialBranding then ["--enable-official-branding"] else []);

  meta = {
    description = "Mozilla Thunderbird, a full-featured email client";
  };
}
