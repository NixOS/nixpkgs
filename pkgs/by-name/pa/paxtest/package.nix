{
  lib,
  stdenv,
  fetchurl,
  paxctl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paxtest";
  version = "0.9.15";

  src = fetchurl {
    url = "https://www.grsecurity.net/~spender/paxtest-${finalAttrs.version}.tar.gz";
    sha256 = "0zv6vlaszlik98gj9200sv0irvfzrvjn46rnr2v2m37x66288lym";
  };

  enableParallelBuilding = true;

  makefile = "Makefile.psm";
  makeFlags = [
    "PAXBIN=${paxctl}/bin/paxctl"
    "BINDIR=$(out)/bin"
    "RUNDIR=$(out)/lib/paxtest"
  ];
  installFlags = [ "DESTDIR=\"\"" ];

  meta = {
    description = "Test various memory protection measures";
    mainProgram = "paxtest";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      joachifm
    ];
  };
})
