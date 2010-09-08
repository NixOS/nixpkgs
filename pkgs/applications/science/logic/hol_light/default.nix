{stdenv, fetchsvn, ocaml, camlp5_transitional}:

stdenv.mkDerivation rec {
  name = "hol_light-${version}";
  version = "20100820svn57";

  inherit ocaml;
  camlp5 = camlp5_transitional;

  src = fetchsvn {
    url = http://hol-light.googlecode.com/svn/trunk;
    rev = "57";
    sha256 = "d1372744abca6c9978673850977d3e1577fd8cfd8298826eb713b3681c10cccd";
  };

  buildInputs = [ ocaml camlp5 ];

  buildCommand = ''
    export HOL_DIR="$out/src/hol_light"
    ensureDir `dirname $HOL_DIR` "$out/bin"
    cp -a "${src}" "$HOL_DIR"
    cd "$HOL_DIR"
    chmod -R u+rwX .

    substituteInPlace hol.ml --replace \
      "(try Sys.getenv \"HOLLIGHT_DIR\" with Not_found -> Sys.getcwd())" \
      "\"$HOL_DIR\""

    substituteInPlace Makefile --replace \
      "+camlp5" \
      "${camlp5}/lib/ocaml/camlp5"

    substitute ${./start_hol_light} "$out/bin/start_hol_light" \
      --subst-var-by OCAML "${ocaml}" \
      --subst-var-by CAMLP5 "${camlp5_transitional}" \
      --subst-var HOL_DIR
    chmod +x "$out/bin/start_hol_light"

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
    homepage = http://www.cl.cam.ac.uk/~jrh13/hol-light/;
    license = "BSD";
    ocamlVersions = [ "3.10.0" "3.11.1" ];
  };
}
