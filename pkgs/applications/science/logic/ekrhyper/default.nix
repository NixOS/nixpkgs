{stdenv, fetchurl, ocaml, perl}:
let
  s = # Generated upstream information
  rec {
    baseName="ekrhyper";
    version="1_4_08022013";
    name="${baseName}-${version}";
    hash="0vni5pq1p99428ii3g13chiqxcs8k1fm6jlvg1jqh4qdcs42w7yb";
    url="http://userpages.uni-koblenz.de/~bpelzer/ekrhyper/ekrh_1_4_08022013.tar.gz";
    sha256="0vni5pq1p99428ii3g13chiqxcs8k1fm6jlvg1jqh4qdcs42w7yb";
  };
  buildInputs = [
    ocaml perl
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  setSourceRoot = "export sourceRoot=$(echo */ekrh/src/)";
  preInstall = "export INSTALLDIR=$out";
  postInstall = ''for i in "$out/casc"/*; do ln -s "$i" "$out/bin/ekrh-casc-$(basename $i)"; done '';
  meta = {
    inherit (s) version;
    description = "Automated first-order theorem prover";
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
