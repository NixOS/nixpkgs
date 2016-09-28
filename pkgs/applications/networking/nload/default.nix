{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  version = "0.7.4";
  name = "nload-${version}";

  src = fetchurl {
    url = "http://www.roland-riegel.de/nload/${name}.tar.gz";
    sha256 = "1rb9skch2kgqzigf19x8bzk211jdfjfdkrcvaqyj89jy2pkm3h61";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "Monitors network traffic and bandwidth usage with ncurses graphs";
    longDescription = ''
      nload is a console application which monitors network traffic and
      bandwidth usage in real time. It visualizes the in- and outgoing traffic
      using two graphs and provides additional info like total amount of
      transfered data and min/max network usage.
    '';
    homepage = http://www.roland-riegel.de/nload/index.html;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
