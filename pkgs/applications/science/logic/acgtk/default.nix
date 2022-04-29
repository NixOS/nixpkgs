{ lib, stdenv, fetchurl, dune_2, ocamlPackages }:

stdenv.mkDerivation {

  pname = "acgtk";
  version = "1.5.2";

  src = fetchurl {
    url = "https://acg.loria.fr/software/acg-1.5.2-20201204.tar.gz";
    sha256 = "09yax7dyw8kgwzlb69r9d20y7rrymzwi3bbq2dh0qdq01vjz2xwq";
  };

  buildInputs = [ dune_2 ] ++ (with ocamlPackages; [
    ocaml findlib ansiterminal cairo2 cmdliner fmt logs menhir menhirLib mtime yojson
  ]);

  buildPhase = "dune build --profile=release";

  installPhase = ''
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR
  '';

  meta = with lib; {
    homepage = "https://acg.loria.fr/";
    description = "A toolkit for developing ACG signatures and lexicon";
    license = licenses.cecill20;
    inherit (ocamlPackages.ocaml.meta) platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
