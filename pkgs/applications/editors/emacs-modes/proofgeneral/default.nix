{ stdenv, fetchurl, emacs, perl }:

let
  pname = "ProofGeneral";
  version = "3.7.1.1";
  name = "${pname}-${version}";
  website = "http://proofgeneral.inf.ed.ac.uk";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.cl.cam.ac.uk/research/hvg/Isabelle/dist/contrib/${name}.tar.gz";
    sha256 = "ae430590d6763618df50a662a37f0627d3c3c8f31372f6f0bb2116b738fc92d8";
  };

  buildInputs = [ emacs perl ];

  sourceRoot = name;

  postPatch = "EMACS=emacs make clean";

  # Skip building ...
  buildPhase = "true";

  installPhase = ''
    DEST=$out/share/emacs/site-lisp/ProofGeneral
    ensureDir $DEST
    cp -a * $DEST
  '';

  meta = {
    description = "A generic front-end for proof assistants";
    longDescription = ''
      Proof General is a generic front-end for proof assistants (also known as
      interactive theorem provers), based on the customizable text editor Emacs.
    '';
    homepage = website;
    license = "GPL";
  };
}
