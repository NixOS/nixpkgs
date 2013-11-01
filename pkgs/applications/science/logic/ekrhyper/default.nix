{stdenv, fetchurl, ocaml, perl}:
let
  s = # Generated upstream information
  rec {
    baseName="ekrhyper";
    version="1_4_30072013";
    name="${baseName}-${version}";
    hash="0ashsblm477r7dmq9f33wajkbr29rbyyc919mifdgrrdy6zlc663";
    url="http://userpages.uni-koblenz.de/~bpelzer/ekrhyper/ekrh_1_4_30072013.tar.gz";
    sha256="0ashsblm477r7dmq9f33wajkbr29rbyyc919mifdgrrdy6zlc663";
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
