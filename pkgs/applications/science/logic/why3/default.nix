{ fetchurl, stdenv, ocaml, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.83";

  src = fetchurl {
    url    = "https://gforge.inria.fr/frs/download.php/33490/${name}.tar.gz";
    sha256 = "1jcs5vj91ppbgh4q4hch89b63wgakjhg35pm3r4jwhp377lnggya";
  };

  buildInputs = with ocamlPackages;
    [ coq ocaml findlib lablgtk ocamlgraph zarith ];

  meta = {
    description = "why is a software verification platform";
    homepage    = "http://why3.lri.fr/";
    license     = stdenv.lib.licenses.lgpl21;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
