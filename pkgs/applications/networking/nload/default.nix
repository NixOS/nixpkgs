{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "0.7.4";
  pname = "nload";

  src = fetchurl {
    url = "http://www.roland-riegel.de/nload/${pname}-${version}.tar.gz";
    sha256 = "1rb9skch2kgqzigf19x8bzk211jdfjfdkrcvaqyj89jy2pkm3h61";
  };

  patches = [
    # Fixes an ugly bug of graphs scrolling to the side, corrupting the view.
    # There is an upstream fix, but not a new upstream release that includes it.
    # Other distributions like Gentoo also patch this as a result; see:
    #   https://github.com/rolandriegel/nload/issues/3#issuecomment-427579143
    # TODO Remove when https://github.com/rolandriegel/nload/issues/3 is merged and available
    (fetchpatch {
      url = "https://github.com/rolandriegel/nload/commit/8a93886e0fb33a81b8fe32e88ee106a581fedd34.patch";
      name = "nload-0.7.4-Eliminate-flicker-on-some-terminals.patch";
      sha256 = "10yppy5l50wzpcvagsqkbyf1rcan6aj30am4rw8hmkgnbidf4zbq";
    })
    # Patches configure.in file to make configure compile on macOS.
    # Patch taken from MacPorts.
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/28814c34711e7545929fd391feb6ce079bd73fd4/net/nload/files/patch-configure.in.diff";
      extraPrefix = "";
      hash = "sha256-lGbBG5ZOgMVnrwlwXVFGbUZx6RkmQwYSVLB3oqkAWRs=";
    })
    # Fixes crash on F2 and garbage in adapter name.
    # Patch taken from Homebrew.
    (fetchpatch {
      url = "https://sourceforge.net/p/nload/bugs/_discuss/thread/c9b68d8e/4a65/attachment/devreader-bsd.cpp.patch";
      extraPrefix = "";
      hash = "sha256-umRQDqcRUOGELOx5iB6CPFRkjaD8HXkMCWiKsYdaUa0=";
    })
  ];

  nativeBuildInputs = lib.optional stdenv.isDarwin autoreconfHook;
  buildInputs = [ ncurses ];

  meta = {
    description = "Monitors network traffic and bandwidth usage with ncurses graphs";
    longDescription = ''
      nload is a console application which monitors network traffic and
      bandwidth usage in real time. It visualizes the in- and outgoing traffic
      using two graphs and provides additional info like total amount of
      transfered data and min/max network usage.
    '';
    homepage = "http://www.roland-riegel.de/nload/index.html";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.devhell ];
    mainProgram = "nload";
  };
}
