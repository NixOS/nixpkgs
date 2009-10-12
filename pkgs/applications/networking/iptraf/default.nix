{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "iptraf-3.0.0";
  
  src = fetchurl {
    url = ftp://iptraf.seul.org/pub/iptraf/iptraf-3.0.0.tar.gz;
    sha256 = "0qsi5f8d84mgdszvz22acyv6mjnbrpk55d54km9i5mkkapck7r4y";
  };

  preConfigure = "cd src";

  installPhase = ''
    ensureDir $out/bin
    cp iptraf $out/bin
  '';
  
  buildInputs = [ncurses];

  meta = {
    homepage = http://iptraf.seul.org/;
    license = "GPLv2+";
    description = "Console-based network statistics utility for Linux";
  };
}
