{ stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi
, libjpeg, libpng, zlib, cairo

, # If you want the resulting program to call itself "Thunderbird"
  # instead of "Deer Park", enable this option.  However, those
  # binaries may not be distributed without permission from the
  # Mozilla Foundation, see
  # http://www.mozilla.org/foundation/trademarks/.
  enableOfficialBranding ? false
    
}:



stdenv.mkDerivation {
  name = "thunderbird-1.5.0.4";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://releases.mozilla.org/pub/mozilla.org/thunderbird/releases/1.5.0.4/source/thunderbird-1.5.0.4-source.tar.bz2;
    sha1 = "492dd76460fc14543a70349263b64b0a2803bee9";
  };

  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
  ];
  inherit gtk;

  configureFlags = [
    "--enable-application=mail"
    "--enable-optimize"
    "--disable-debug"
    "--enable-xft"
    "--disable-freetype2"
    "--enable-svg"
    "--enable-strip"
    "--enable-default-toolkit=gtk2"
    "--with-system-jpeg"
    "--with-system-png"
    "--with-system-zlib"
    "--with-system-cairo"
  ]
  ++ (if enableOfficialBranding then ["--enable-official-branding"] else []);
}
