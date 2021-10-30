{lib, stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  pname = "iptraf";
  version = "3.0.1";

  src = fetchurl {
    url = "ftp://iptraf.seul.org/pub/iptraf/iptraf-${version}tar.gz";
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
    homepage = "http://iptraf.seul.org/";
    license = lib.licenses.gpl2Plus;
    description = "Console-based network statistics utility for Linux";
    platforms = lib.platforms.linux;
    broken = true; # required isdn headers have been removed from the linux kernel
  };
}
