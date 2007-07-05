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
  name = "thunderbird-1.5.0.10";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://releases.mozilla.org/pub/mozilla.org/thunderbird/releases/1.5.0.10/source/thunderbird-1.5.0.10-source.tar.bz2;
    sha1 = "a6467c946f9e668bcf7b3a06dcaeceb601b98fce";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
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
