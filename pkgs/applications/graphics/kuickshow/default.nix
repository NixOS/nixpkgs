{ stdenv, fetchurl, kdelibs, imlib, cmake, pkgconfig, gettext }:

stdenv.mkDerivation rec {
  name = "kuickshow-0.9.1";

  src = fetchurl {
    url = "http://hosti.leonde.de/~gis/${name}.tar.bz2";
    sha256 = "0l488a6p0ligbhv6p1lnx5k2d00x9bkkvms30winifa8rmisa9wl";
  };

  buildInputs = [ kdelibs imlib ];

  buildNativeInputs = [ cmake gettext pkgconfig ];
}
