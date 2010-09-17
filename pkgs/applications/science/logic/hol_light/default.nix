{stdenv, writeText, writeTextFile, ocaml, camlp5_transitional, hol_light_sources}:

let
  version = hol_light_sources.version;

  camlp5 = camlp5_transitional;

  hol_light_src_dir = "${hol_light_sources}/lib/hol_light/src";

  pa_j_cmo = stdenv.mkDerivation {
    name = "pa_j.cmo";
    inherit ocaml camlp5; 
    buildInputs = [ ocaml camlp5 ];
    buildCommand = ''
      ocamlc -c \
        -pp "camlp5r pa_lexer.cmo pa_extend.cmo q_MLast.cmo" \
        -I "${camlp5}/lib/ocaml/camlp5" \
        -o $out \
        "${hol_light_src_dir}/pa_j_`ocamlc -version | cut -c1-4`.ml"
      '';
    };

  start_ml = writeText "start.ml" ''
    Topdirs.dir_directory "${hol_light_src_dir}";;
    Topdirs.dir_directory "${camlp5}/lib/ocaml/camlp5";;
    Topdirs.dir_load Format.std_formatter "camlp5o.cma";;
    Topdirs.dir_load Format.std_formatter "${pa_j_cmo}";;
    #use "${hol_light_src_dir}/make.ml";;
  '';
in
writeTextFile {
  name = "hol_light-${version}";
  destination = "/bin/start_hol_light";
  executable = true;
  text = ''
      #!/bin/sh
      exec ${ocaml}/bin/ocaml -init ${start_ml}
    '';
} // {
  inherit (hol_light_sources) version src;
  meta = {
    description = "An interactive theorem prover based on Higher-Order Logic.";
    longDescription = ''
HOL Light is a computer program to help users prove interesting mathematical
theorems completely formally in Higher-Order Logic.  It sets a very exacting
standard of correctness, but provides a number of automated tools and
pre-proved mathematical theorems (e.g., about arithmetic, basic set theory and
real analysis) to save the user work.  It is also fully programmable, so users
can extend it with new theorems and inference rules without compromising its
soundness.
    '';
    homepage = http://www.cl.cam.ac.uk/~jrh13/hol-light/;
    license = "BSD";
  };
}
