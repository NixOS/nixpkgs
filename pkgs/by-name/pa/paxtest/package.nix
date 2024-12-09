{ lib, stdenv, fetchurl, paxctl }:

stdenv.mkDerivation rec {
  pname = "paxtest";
  version = "0.9.15";

  src = fetchurl {
    url    = "https://www.grsecurity.net/~spender/${pname}-${version}.tar.gz";
    sha256 = "0zv6vlaszlik98gj9200sv0irvfzrvjn46rnr2v2m37x66288lym";
  };

  enableParallelBuilding = true;

  makefile     = "Makefile.psm";
  makeFlags    = [ "PAXBIN=${paxctl}/bin/paxctl" "BINDIR=$(out)/bin" "RUNDIR=$(out)/lib/paxtest" ];
  installFlags = [ "DESTDIR=\"\"" ];

  meta = with lib; {
    description = "Test various memory protection measures";
    mainProgram = "paxtest";
    license     = licenses.gpl2Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin joachifm ];
  };
}
