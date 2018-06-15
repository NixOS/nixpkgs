{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "iptraf-3.0.1";

  src = fetchurl {
    url = ftp://iptraf.seul.org/pub/iptraf/iptraf-3.0.1.tar.gz;
    sha256 = "12n059j9iihhpf6spmlaspqzxz3wqan6kkpnhmlj08jdijpnk84m";
  };

  hardeningDisable = [ "format" ];

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
    platforms = stdenv.lib.platforms.linux;
  };
}
