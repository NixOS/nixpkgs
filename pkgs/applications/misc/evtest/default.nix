{ stdenv, fetchgit, autoconf, automake, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  name = "evtest-1.30";

  preConfigure = "autoreconf -iv";

  buildInputs = [ autoconf automake pkgconfig libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/evtest";
    rev = "1a50f2479c4775e047f234a24d95dda82441bfbd";
  };

  meta = {
    description = "Simple tool for input event debugging";
    license = "GPLv2";
  };
}
