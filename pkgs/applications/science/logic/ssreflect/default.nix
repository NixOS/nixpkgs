# TODO:
# - coq needs to be invoked with the explicit path to the ssreflect theory
#   e.g. coqide -R ~/.nix-profile/lib/coq/user-contrib/ ''

{stdenv, fetchurl, ocaml, camlp5, coq, makeWrapper}:

let
  pname = "ssreflect";
  version = "1.3pl4";
  name = "${pname}-${version}";
  webpage = http://www.msr-inria.inria.fr/Projects/math-components;
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "${webpage}/${name}.tar.gz";
    sha256 = "1ha3iiqq79pgll5ra9z0xdi3d3dr3wb9f5vsm4amy884l5anva02";
  };

  buildInputs = [ ocaml camlp5 coq makeWrapper ];

  patches = [ ./static.patch ];

  postBuild = ''
    cd src
    coqmktop -ide -opt ssreflect.cmx -o ../bin/ssrcoqide
    cd ..
  '';

  installPhase = ''
    COQLIB=$out/lib/coq make -f Makefile.coq install -e
    mkdir -p $out/bin
    cp bin/* $out/bin
#    for i in $out/bin/*; do
#      wrapProgram "$i" \
#        --add-flags "-R" \
#        --add-flags "$out/lib/coq/user-contrib/Ssreflect" \
#        --add-flags "Ssreflect"
#    done
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
