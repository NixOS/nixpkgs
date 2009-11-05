# TODO:
# - ssrcoqide does not build successfully (missing coqide libraries in the coq installation).
# - ssrcoq needs to be invoked with the explicit path to the ssreflect theory
#   e.g.. ssrcoq -I /nix/store/rp09dlb2y2hpddb0xa7fyrgjlzb284ar-ssreflect-1.2/lib/coq/user-contrib/theories/

{stdenv, fetchurl, ocaml, camlp5, coq}:

let
  pname = "ssreflect";
  version = "1.2";
  name = "${pname}-${version}";
  webpage = http://www.msr-inria.inria.fr/Projects/math-components;
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "${webpage}/${name}.tgz";
    sha256 = "0800b085e6a0caec5093c6c02aacdd8dfd9cc282177e8586f14f9a9e15f64d0b";
  };

  buildInputs = [ ocaml camlp5 coq ];

  preBuild = ''
    coq_makefile -f Make -o Makefile
    substituteInPlace Makefile \
      --replace 'install -D $$i $(COQLIB)' 'install -D $$i '$out'/lib/coq'
  '';

  # this fails
  /*
  postBuild = ''
    cd src
    coqmktop -ide -opt ssreflect.cmx -o ../bin/ssrcoqide
  '';
  */

  postInstall = ''
    ensureDir $out/bin
    #cp -a bin/ssrcoq bin/ssrcoqide $out/bin
    cp -a bin/ssrcoq $out/bin
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
