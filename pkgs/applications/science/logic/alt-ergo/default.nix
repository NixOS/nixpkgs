{ fetchurl, stdenv, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "alt-ergo-${version}";
  version = "2.2.0";

  src = fetchurl {
    url    = "https://alt-ergo.ocamlpro.com/download_manager.php?target=${name}.tar.gz";
    name   = "${name}.tar.gz";
    sha256 = "106zfgisq6qxr7dlk8z7gi68ly7qff4frn8wab2g8z2nkkwla92w";
  };

  buildInputs = with ocamlPackages;
    [ ocaml findlib camlzip ocamlgraph zarith lablgtk ocplib-simplex psmt2-frontend menhir num ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = stdenv.lib.licenses.ocamlpro_nc;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
