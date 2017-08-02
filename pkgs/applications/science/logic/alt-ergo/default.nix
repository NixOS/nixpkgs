{ fetchurl, stdenv, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "alt-ergo-${version}";
  version = "1.30";

  src = fetchurl {
    url    = "http://alt-ergo.ocamlpro.com/download_manager.php?target=${name}.tar.gz";
    name   = "${name}.tar.gz";
    sha256 = "025pacb4ax864fn5x8k78mw6hiig4jcazblj18gzxspg4f1l5n1g";
  };

  buildInputs = with ocamlPackages;
    [ ocaml findlib camlzip ocamlgraph zarith lablgtk ocplib-simplex ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = stdenv.lib.licenses.cecill-c; # LGPL-2 compatible
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
