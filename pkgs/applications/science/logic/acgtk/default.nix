{ stdenv, fetchurl, dune, ocamlPackages }:

stdenv.mkDerivation {

  pname = "acgtk";
  version = "1.5.1";

  src = fetchurl {
    url = https://acg.loria.fr/software/acg-1.5.1-20191113.tar.gz;
    sha256 = "17595qfwhzz5q091ak6i6bg5wlppbn8zfn58x3hmmmjvx2yfajn1";
  };

  buildInputs = [ dune ] ++ (with ocamlPackages; [
    ocaml findlib ansiterminal cairo2 cmdliner fmt logs menhir mtime yojson
  ]);

  buildPhase = "dune build";

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = https://acg.loria.fr/;
    description = "A toolkit for developing ACG signatures and lexicon";
    license = licenses.cecill20;
    inherit (ocamlPackages.ocaml.meta) platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
