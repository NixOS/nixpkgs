{ lib, stdenv, fetchurl, ocaml, perl }:

stdenv.mkDerivation rec {
  pname = "ekrhyper";
  version = "1_4_21022014";

  src = fetchurl {
    url = "http://userpages.uni-koblenz.de/~bpelzer/ekrhyper/ekrh_${version}.tar.gz";
    sha256 = "sha256-fEe0DIMGj7wO+79/BZf45kykgyTXpbZJsyFSt31XqpM=";
  };

  strictDeps = true;
  nativeBuildInputs = [ ocaml perl ];
  setSourceRoot = "export sourceRoot=$(echo */ekrh/src/)";
  preInstall = "export INSTALLDIR=$out";
  postInstall = ''for i in "$out/casc"/*; do ln -s "$i" "$out/bin/ekrh-casc-$(basename $i)"; done '';

  meta = with lib; {
    description = "Automated first-order theorem prover";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
