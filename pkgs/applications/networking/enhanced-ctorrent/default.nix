{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "dnh3.3.2";
  name = "enhanced-ctorrent";
  src = fetchurl {
    url = "http://www.rahul.net/dholmes/ctorrent/ctorrent-dnh3.3.2.tar.gz";
    sha256 = "0qs8waqwllk56i3yy3zhncy7nsnhmf09a494p5siz4vm2k4ncwy8";
  };

  meta = {
    description = "BitTorrent client written in C++";
    longDescription = ''
      CTorrent, a BitTorrent client implemented in C++, with bugfixes and
      performance enhancements.
    '';
    homepage = http://www.rahul.net/dholmes/ctorrent/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
