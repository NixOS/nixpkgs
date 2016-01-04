{ fetchurl, stdenv, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "alt-ergo-${version}";
  version = "0.99.1";

  src = fetchurl {
    url    = "http://alt-ergo.ocamlpro.com/download_manager.php?target=${name}.tar.gz";
    name   = "${name}.tar.gz";
    sha256 = "0lnlf56ysisa45dxvbwzhl4fgyxyfz35psals2kv9x8gyq54zwpm";
  };

  buildInputs = with ocamlPackages;
    [ ocaml findlib ocamlgraph zarith lablgtk ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "http://alt-ergo.ocamlpro.com/";
    license     = stdenv.lib.licenses.cecill-c; # LGPL-2 compatible
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
