{ fetchurl, stdenv, ocaml, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "alt-ergo-${version}";
  version = "0.95.2";

  src = fetchurl {
    url    = "http://alt-ergo.ocamlpro.com/download_manager.php?target=${name}.tar.gz";
    name   = "${name}.tar.gz";
    sha256 = "1b7f0rh3jgm67g0x2m3wv7gnnqmz9cjlrfm136z56ihlkhsd8v2s";
  };

  buildInputs = with ocamlPackages;
    [ ocaml findlib ocamlgraph zarith lablgtk ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "http://alt-ergo.ocamlpro.com/";
    license     = stdenv.lib.licenses.cecill-c; # LGPL-2 compatible
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
