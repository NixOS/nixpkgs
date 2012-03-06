# TODO:
# - coq needs to be invoked with the explicit path to the ssreflect theory
#   e.g. coqide -R ~/.nix-profile/lib/coq/user-contrib/ ''

{stdenv, fetchurl, ocaml, camlp5, coq}:

let
  pname = "ssreflect";
  version = "1.3pl1";
  name = "${pname}-${version}";
  webpage = http://www.msr-inria.inria.fr/Projects/math-components;
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "${webpage}/${name}.tar.gz";
    sha256 = "0ykrhqb68aanl5d4dmn0vnx8m34gg0jsbdhwx2852rqi7r00b9ri";
  };

  buildInputs = [ ocaml camlp5 coq ];

  # this fails
  /*
  postBuild = ''
    cd src
    coqmktop -ide -opt ssreflect.cmx -o ../bin/ssrcoqide
  '';
  */

  installPhase = ''
    COQLIB=$out/lib/coq make -f Makefile.coq install -e
    mkdir -p $out/bin
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
  };
}
