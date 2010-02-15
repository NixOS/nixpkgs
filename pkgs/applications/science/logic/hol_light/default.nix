{stdenv, fetchurl, ocaml_with_sources}:

let
  pname = "hol_light";
  version = "100110";
  webpage = http://www.cl.cam.ac.uk/~jrh13/hol-light/;

  dmtcp_checkpoint = ''

(* ------------------------------------------------------------------------- *)
(* Non-destructive checkpoint using DMTCP.                                   *)
(* ------------------------------------------------------------------------- *)

let dmtcp_checkpoint bannerstring =
  let longer_banner = startup_banner ^ " with DMTCP" in
  let complete_banner =
    if bannerstring = "" then longer_banner
    else longer_banner^"\n        "^bannerstring in
  (Gc.compact(); Unix.sleep 1;
   try ignore(Unix.system ("dmtcp_command -bc")) with _ -> ();
   Format.print_string complete_banner;
   Format.print_newline(); Format.print_newline());;
  '';

in

stdenv.mkDerivation {
  name = "${pname}-${version}";
  inherit version;

  src = fetchurl {
    url = "${webpage}${pname}_${version}.tgz";
    sha256 = "1jkn9vpl3n9dgb96zwmly32h1p3f9mcf34pg6vm0fyvqp9kbx3ac";
  };

  buildInputs = [ ocaml_with_sources ];

  buildCommand = ''
    ensureDir "$out/src"
    cd "$out/src"

    tar -xzf "$src"
    cd hol_light

    substituteInPlace hol.ml --replace \
      "(try Sys.getenv \"HOLLIGHT_DIR\" with Not_found -> Sys.getcwd())" \
      "\"$out/src/hol_light\""

    substituteInPlace Examples/update_database.ml --replace \
      "Filename.concat ocaml_source_dir" \
      "Filename.concat \"${ocaml_with_sources}/src/ocaml\""

    echo '${dmtcp_checkpoint}' >> make.ml

    make
  '';

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
    homepage = webpage;
    license = "BSD";
  };
}
