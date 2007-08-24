{stdenv, fetchurl, perl
, bison, flex, glib
, pkgconfig, libxml2}:

stdenv.mkDerivation {
  name = "GStreamer-0.10.10";
  src = fetchurl {
    url = http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.10.tar.bz2;
    md5 = "6875bf0bd3cf38b9ae1362b9e644e6fc" ;
  };

  buildInputs = [perl bison flex glib pkgconfig libxml2];
}
