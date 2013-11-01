{stdenv, fetchsvn, writeScript, ocaml, findlib, camlp5}:

let
  start_script = ''
    #!/bin/sh
    cd "$out/lib/hol_light"
    exec ${ocaml}/bin/ocaml -I "camlp5 -where" -init make.ml
  '';
in

stdenv.mkDerivation {
  name = "hol_light-20130324";
  src = fetchsvn {
    url = http://hol-light.googlecode.com/svn/trunk;
    rev = "157";
    sha256 = "0d0pbnkw2gb11dn30ggfl91lhdxv86kd1fyiqn170w08n0gi805f";
  };

  buildInputs = [ ocaml findlib camlp5 ];

  installPhase = ''
    mkdir -p "$out/lib/hol_light" "$out/bin"
    cp -a  . $out/lib/hol_light
    echo "${start_script}" > "$out/bin/hol_light"
    chmod a+x "$out/bin/hol_light"
  '';

  meta = {
    description = "Interactive theorem prover based on Higher-Order Logic";
    longDescription = ''
      HOL Light is a computer program to help users prove interesting
      mathematical theorems completely formally in Higher-Order Logic.  It sets
      a very exacting standard of correctness, but provides a number of
      automated tools and pre-proved mathematical theorems (e.g., about
      arithmetic, basic set theory and real analysis) to save the user work.
      It is also fully programmable, so users can extend it with new theorems
      and inference rules without compromising its soundness.
    '';
    homepage = http://www.cl.cam.ac.uk/~jrh13/hol-light/;
    license = stdenv.lib.licenses.bsd2;
  };
}
