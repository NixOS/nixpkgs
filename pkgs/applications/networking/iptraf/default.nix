{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "iptraf-3.0.1";
  
  src = fetchurl {
    url = ftp://iptraf.seul.org/pub/iptraf/iptraf-3.0.1.tar.gz;
    md5 = "004c2c005a1b78739e22bc49d33e244d";
  };

  patchPhase = ''
    sed -i -e 's,#include <linux/if_tr.h>,#include <netinet/if_tr.h>,' src/*
  '';

  preConfigure = "cd src";

  installPhase = ''
    mkdir -p $out/bin
    cp iptraf $out/bin
  '';
  
  buildInputs = [ncurses];

  meta = {
    homepage = http://iptraf.seul.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Console-based network statistics utility for Linux";
  };
}
