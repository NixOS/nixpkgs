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
  version = "2.0.36";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI-${version}.tar.gz";
    sha256 = "sha256-oEAxSPpfe+2TDJWKTRxVgEfic3Y6QIs6A2jtwTfMVdk=";
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

  meta = with lib; {
    homepage = "https://openipmi.sourceforge.io/";
    description = "User-level library that provides a higher-level abstraction of IPMI and generic services";
    license = with licenses; [
      gpl2Only
      lgpl2Only
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ arezvov ] ++ teams.c3d2.members;
  };
}
