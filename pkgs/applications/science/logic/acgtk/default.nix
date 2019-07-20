{ stdenv, fetchurl, dune, ocamlPackages }:

stdenv.mkDerivation {

  name = "acgtk-1.5.0";

  src = fetchurl {
    url = http://calligramme.loria.fr/acg/software/acg-1.5.0-20181019.tar.gz;
    sha256 = "14n003gxzw5w79hlpw1ja4nq97jqf9zqyg00ihvpxw4bv9jlm8jm";
  };

  buildInputs = [ dune ] ++ (with ocamlPackages; [
    ocaml findlib ansiterminal cairo2 fmt logs menhir mtime ocf
  ]);

  buildPhase = "dune build";

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = http://calligramme.loria.fr/acg/;
    description = "A toolkit for developing ACG signatures and lexicon";
    license = licenses.cecill20;
    inherit (ocamlPackages.ocaml.meta) platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
