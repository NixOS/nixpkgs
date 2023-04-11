{ lib, stdenv, fetchurl, expat }:

stdenv.mkDerivation rec {
  pname = "sblg";
  version = "0.5.11";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/sblg/snapshots/sblg.tar.gz";
    sha512 = "2741ce27172d702b2f0165d2fe796896fbc2a08b838e486aa61b9ccfe629ba0a09d5e1e9bbea168425c592bb39ae1cc073e0259772009bad5c7186f64558c93c";
  };

  buildInputs = [ expat ];

  configurePhase = ''
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                MANDIR=''${!outputMan}/share/man
  '';

  installTarget = "install";

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkTarget = "regress";

  meta = with lib; {
    homepage = "https://kristaps.bsd.lv/sblg/";
    description = "Static blog utility";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
