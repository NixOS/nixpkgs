{ stdenv, fetchurl, libotr, automake, autoconf, libtool, glib, pkgconfig, irssi }:

let
  rev = "640e98c74b";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "irssi-otr-20131007-${rev}";
  
  src = fetchurl {
    url = "https://github.com/cryptodotis/irssi-otr/tarball/${rev}";
    name = "${name}.tar.gz";
    sha256 = "0d08ianzhy20w0ld8xx7hgrp9psg54l37619pcdpqyrnlzkkdalz";
  };

  patchPhase = ''
    sed -i 's,/usr/include/irssi,${irssi}/include/irssi,' src/Makefile.am
    sed -i "s,/usr/lib/irssi,$out/lib/irssi," configure.ac
    sed -i "s,/usr/share/irssi,$out/share/irssi," help/Makefile.am
  '';

  preConfigure = "sh ./bootstrap";

  buildInputs = [ libotr automake autoconf libtool glib pkgconfig irssi ];
  
  meta = {
    homepage = https://github.com/cryptodotis/irssi-otr;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
