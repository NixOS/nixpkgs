{ fetchFromGitHub, lib, which, ocamlPackages }:

let
  pname = "alt-ergo";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = pname;
    rev = version;
    sha256 = "1jm1yrvsg8iyfp9bb728zdx2i7yb6z7minjrfs27k5ncjqkjm65g";
  };

  useDune2 = true;

  nativeBuildInputs = [ which ];

in

let alt-ergo-lib = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-lib";
  inherit version src useDune2 nativeBuildInputs;
  configureFlags = pname;
  buildInputs = with ocamlPackages; [ dune-configurator ];
  propagatedBuildInputs = with ocamlPackages; [ num ocplib-simplex stdlib-shims zarith ];
}; in

let alt-ergo-parsers = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-parsers";
  inherit version src useDune2 nativeBuildInputs;
  configureFlags = pname;
  buildInputs = with ocamlPackages; [ menhir ];
  propagatedBuildInputs = [ alt-ergo-lib ] ++ (with ocamlPackages; [ camlzip psmt2-frontend ]);
}; in

ocamlPackages.buildDunePackage {

  inherit pname version src useDune2 nativeBuildInputs;

  configureFlags = pname;

  buildInputs = [ alt-ergo-parsers ] ++ (with ocamlPackages; [
    cmdliner menhir ])
  ;

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = lib.licenses.ocamlpro_nc;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
