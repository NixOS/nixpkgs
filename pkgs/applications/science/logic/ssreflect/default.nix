# TODO:
# - coq needs to be invoked with the explicit path to the ssreflect theory
#   e.g. coqide -R ~/.nix-profile/lib/coq/user-contrib/ ''

{stdenv, fetchurl, ocaml, camlp5, coq, makeWrapper}:

let
  pname = "ssreflect";
  version = "1.5";
  name = "${pname}-${version}";
  webpage = http://www.msr-inria.inria.fr/Projects/math-components;
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://ssr.msr-inria.inria.fr/FTP/${name}.tar.gz";
    sha256 = "0hm1ha7sxqfqhc7iwhx6zdz3nki4rj5nfd3ab24hmz8v7mlpinds";
  };

  buildInputs = [ ocaml camlp5 coq makeWrapper ];

  patches = [ ./static.patch ];

  installPhase = ''
    COQLIB=$out/lib/coq/ make -f Makefile.coq install -e
    mkdir -p $out/bin
    cp bin/* $out/bin
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --add-flags "-R" \
        --add-flags "$out/lib/coq/user-contrib/Ssreflect" \
        --add-flags "Ssreflect"
    done
    makeWrapper "${coq}/bin/coqide" "$out/bin/ssrcoqide" --add-flags "-coqtop" --add-flags "$out/bin/ssrcoq"
  '';

  meta = {
    description = "Small Scale Reflection extension for Coq";
    longDescription = ''
      Small Scale Reflection (ssreflect) is an extension of the Coq Theorem
      Prover which enable a formal proof methodology based on the pervasive
      use of computation with symbolic representation
    '';
    homepage = webpage;
    license = "CeCILL B FREE SOFTWARE LICENSE or CeCILL FREE SOFTWARE LICENSE";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
