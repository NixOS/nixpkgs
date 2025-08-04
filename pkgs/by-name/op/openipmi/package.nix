{
  stdenv,
  fetchurl,
  popt,
  ncurses,
  python3,
  readline,
  lib,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "OpenIPMI";
  version = "2.0.37";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI-${version}.tar.gz";
    sha256 = "sha256-xi049dp99Cmaw6ZSUI6VlTd1JEAYHjTHayrs69fzAbk=";
  };

  buildInputs = [
    ncurses
    popt
    python3
    readline
    openssl
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  meta = {
    homepage = "https://openipmi.sourceforge.io/";
    description = "User-level library that provides a higher-level abstraction of IPMI and generic services";
    license = with lib.licenses; [
      gpl2Only
      lgpl2Only
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ arezvov ];
    teams = [ lib.teams.c3d2 ];
  };
}
