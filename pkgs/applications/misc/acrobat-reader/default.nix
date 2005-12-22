{ xineramaSupport ? false
, stdenv, fetchurl, libXt, libXp, libXext, libX11, libXinerama ? null
, glib, pango, atk, gtk, libstdcpp5, zlib
, fastStart ? false
}:

stdenv.mkDerivation {
  name = "acrobat-reader-7.0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ardownload.adobe.com/pub/adobe/reader/unix/7x/7.0/enu/AdbeRdr701_linux_enu.tar.gz;
    md5 = "79e5a40aca6b49f7015cb1694876f87a";
  };
  libPath = [
    libXt libXp libXext libX11 glib pango atk gtk libstdcpp5 zlib
    (if xineramaSupport then libXinerama else null)
  ];
  inherit fastStart;
}
