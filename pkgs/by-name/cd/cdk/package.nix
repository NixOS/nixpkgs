{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "cdk";
  version = "5.0-20221025";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/cdk/cdk-${version}.tgz"
      "https://invisible-mirror.net/archives/cdk/cdk-${version}.tgz"
    ];
    hash = "sha256-A8z6Icn8PWHd0P2hnaVFNZBVu+71ociC37n/SPN0avI=";
  };

  buildInputs = [
    ncurses
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Curses development kit";
    homepage = "https://invisible-island.net/cdk/";
    changelog = "https://invisible-island.net/cdk/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
