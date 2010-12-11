{ stdenv, fetchurl, perl, nettools, polyml, proofgeneral }:
# nettools needed for hostname

let
  pname = "Isabelle";
  version = "2009-2";
  name = "${pname}${version}";
  theories = ["HOL" "FOL" "ZF"];
in

stdenv.mkDerivation {
  inherit name theories;

  src = fetchurl {
    url = "http://www.cl.cam.ac.uk/research/hvg/${pname}/dist/${name}.tar.gz";
    sha256 = "f92a275b78bd8844de47a5902e339b58f3b768c07a7fb19d8e606b68499d5ac4";
  };

  buildInputs = [ perl polyml nettools ];

  sourceRoot = name;

  patches = [ ./settings.patch ];

  postPatch = ''
    ENV=$(type -p env)
    patchShebangs "."
    substituteInPlace lib/Tools/env \
      --replace /usr/bin/env $ENV
    substituteInPlace lib/Tools/install \
      --replace /usr/bin/env $ENV
    substituteInPlace src/Pure/IsaMakefile \
      --replace /bin/bash /bin/sh
    substituteInPlace etc/settings \
      --subst-var-by ML_HOME "${polyml}/bin" \
      --subst-var-by PROOFGENERAL_HOME "${proofgeneral}/share/emacs/site-lisp/ProofGeneral"
  '';

  buildPhase = ''
    ./build $theories
  '';

  installPhase = ''
    ensureDir $out/bin
    mv $TMP/$name $out
    cd $out/$name
    bin/isabelle install -p $out/bin
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
  };
}
