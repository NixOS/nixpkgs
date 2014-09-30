{ stdenv, fetchurl, perl, nettools, polyml, proofgeneral }:
# nettools needed for hostname

let
  dirname = "Isabelle2014";
  theories = ["HOL" "FOL" "ZF"];
in

stdenv.mkDerivation {
  name = "isabelle-2014";
  inherit dirname theories;

  src = if stdenv.isDarwin
    then fetchurl {
      url = http://isabelle.in.tum.de/dist/Isabelle2014_macos.tar.gz;
      sha256 = "1aa3vz2nnkkyd4mlsqbs69jqfxlll5h0k5fj9m1j9wqiddqwvwcf";
    }
    else fetchurl {
      url = http://isabelle.in.tum.de/dist/Isabelle2014_linux.tar.gz;
      sha256 = "0l17s41hwzma0q2glpxrzic8i6mqd9b7awlpwhz0jkli7fj6ny7b";
    };

  buildInputs = [ perl polyml ]
             ++ stdenv.lib.optional (!stdenv.isDarwin) nettools;

  sourceRoot = dirname;

  postPatch = ''
    ENV=$(type -p env)
    patchShebangs "."
    substituteInPlace lib/Tools/env \
      --replace /usr/bin/env $ENV
    substituteInPlace lib/Tools/install \
      --replace /usr/bin/env $ENV
    substituteInPlace etc/settings \
      --subst-var-by ML_HOME "${polyml}/bin" \
      --subst-var-by PROOFGENERAL_HOME "${proofgeneral}/share/emacs/site-lisp/ProofGeneral"
  '';

  buildPhase = ''
    ./bin/isabelle build -s $theories
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $TMP/$dirname $out
    cd $out/$dirname
    bin/isabelle install $out/bin
  '';

  meta = {
    description = "A generic proof assistant";

    longDescription = ''
      Isabelle is a generic proof assistant.  It allows mathematical formulas
      to be expressed in a formal language and provides tools for proving those
      formulas in a logical calculus.
    '';
    homepage = http://isabelle.in.tum.de/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.jwiegley ];
  };
}
